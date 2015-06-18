# Copyright (c) 2015, Salesforce.com, Inc.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.

# * Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.

# * Neither the name of Salesforce.com nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

module FailureRateModule

  ### calculate and save the failure rate for scenarios
  def check_past_failures(scenario)
    # load the failure rate config settings
    config = OpenStruct.new(YAML.load_file(METRICS_CONFIG_FILE)).failure_rate
    machines = Array.new

    # only useful if the regex is in the config file
    unless config['machines_regex'] == nil
      config['machines_regex'].each do |r|
        machines << r.gsub('/', '')
      end
    end
    machines.uniq!

    scenario = scenario.strip[0..255].gsub('\'', '')
    period = parse_time_period(config['time_period'])

    sql = "SELECT s.id, COUNT(*) as count FROM scenarios s
             LEFT JOIN scenario_test_runs str ON str.scenario_id = s.id
           WHERE s.scenario_name like \'#{scenario}\'
             AND test_run_at > DATE_SUB(NOW(), INTERVAL #{period.upcase})"

    # find the machines used to calculate failure rate
    # if not configured, will not add to query
    machines.each_with_index do |reg, i|
      if i == 0
        sql += " AND (machine_name RLIKE '#{reg}' "
      else
        sql += "OR machine_name RLIKE '#{reg}' "
      end
      sql += ") " if i == machines.size - 1
    end

    scenario_id = 0
    all_tests = 0
    failed_tests = 0

    Database.query(sql).each do |r|
      all_tests = r["count"]
      scenario_id = r["id"]
    end

    # this is required if the query above returns a count of 0; we still want
    # to update the failure rate, but we need the scenario ID to do so
    if scenario_id == 0 || scenario_id == nil
      scenario_sql = "SELECT id FROM scenarios WHERE scenario_name like '#{scenario}'"
      Database.query(scenario_sql).each do |r|
        scenario_id = r["id"]
      end
    end

    sql = sql + " AND (passed is NULL OR passed = 0)"

    Database.query(sql).each do |r|
      failed_tests = r["count"]
    end

    # prevents divide by zero errors when no test runs in db
    ratio = all_tests > 0 ? failed_tests.fdiv(all_tests) : 0
    # get threshold from config settings and make sure it's less than 1
    threshold = config['threshold']
    if threshold == nil || threshold >= 1
      threshold = 0.05
    end

    readable_period = period.split(' ')
    if readable_period[0].to_i > 1
      readable_period[1] += "s"
    end

    body_text = "\n#{(ratio * 100).round}% of the test runs for \"#{scenario}\"
    have failed in the past #{readable_period.join(' ').downcase}. You'd better get some eyes on it.\n\n"

    if ratio > threshold
      puts body_text
    end

    # update the scenarios table with the failure rate
    insert_sql = "UPDATE scenarios SET failure_rate = #{ratio * 100} WHERE id = #{scenario_id}"
    Database.query(insert_sql)
  end

  # basically, we need a format MySQL will recognize. That means an integer
  # followed by a specific interval type. It is currently restricted to days,
  # weeks, months, quarters, and years. See the MySQL developers site:
  # https://dev.mysql.com/doc/refman/5.5/en/date-and-time-functions.html#function_date-add
  # Override valid_times and default_time_period to change the defaults
  def parse_time_period(period)
    if period == nil
      default_time_period
    else
      period = period.split(' ')
      if period.size != 2 || period[0] == nil || period[1] == nil
        default_time_period
      elsif valid_times.include?(period[1].upcase) && period[0].strip =~ /\d+/
        period.join(' ')
      else
        default_time_period
      end
    end
  end

  def valid_times
    %w(DAY WEEK MONTH QUARTER YEAR)
  end

  def default_time_period
    "1 WEEK"
  end

end