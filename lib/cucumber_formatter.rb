=begin
Copyright (c) 2015, Salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation and/or
  other materials provided with the distribution.

* Neither the name of Salesforce.com nor the names of its contributors may be
  used to endorse or promote products derived from this software without specific
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
=end

class CucumberFormatter

  def initialize(step_mother, io, options)
    puts "Initializing CucumberMetrics ...\n\n\n"
  end

  def before_feature(feature)
    @background = true
    @scenario_counter ||= 0

    @scenario = feature.feature_elements[@scenario_counter]
    @scenario_counter += 1
    save_str_start_time
  end

  # the first set of background steps don't call this method (cucumber 1.3.19) - instead
  # before_feature is called.
  def before_feature_element(scenario)
    unless @background
      @scenario = scenario
      save_str_start_time
    end
  end

  #save the step
  def after_step(step)
    step_name = get_step_name(@scenario)
    # background steps seem to be adding an extra after_step call. This is above and beyond
    # the fact that they don't call before_feature_elements until after the background
    # executes
    unless step_name == nil
      step_name = step_name.strip[0..255].gsub('\'', '')
    end
    @start_time = @end_time
    @end_time = Time.now

    sql = "INSERT INTO scenario_steps (scenario_test_run_id, name, elapsed_time, created_at, updated_at)
           VALUES (#{@str_id}, \'#{step_name}\', #{(@end_time - @start_time).round}, now(), now())"
    @dbm.query sql unless step_name == nil
  end

  #finish saving the test run
  def after_feature_element(scenario)
    scenario.failed? ? passed = 0 : passed = 1

    sql = "UPDATE scenario_test_runs SET elapsed_time = #{Time.now - @scenario_time_start}, passed = #{passed},
           updated_at = now() WHERE id = #{@str_id}"
    @dbm.query sql

    if scenario.failed?
      save_links(scenario)
    end
    #reset step counter when scenario is finished
    @step_counter = 0
    # clear the background flag - it seems to only happen once
    @background = false
  end

  private

  def save_str_start_time
    ###############
    @scenario_time_start = Time.now

    @start_time = Time.now
    @end_time = Time.now
    machine_name = Socket.gethostname

    @dbm ||= dbm

    if @scenario == nil
      fail "The scenario did not run"
    end

    get_scenario_id(@scenario)
    get_environment_id
    get_browser_id

    save_test_run(machine_name)
    save_tags
  end

  def save_tags
    # extract and save the tags
    tags = extract_tags
    tags.each do |t|
      sql = "INSERT INTO scenario_tags (scenario_test_run_id, tag_name, created_at, updated_at)
             VALUES (#{@str_id}, \'#{t}\', now(), now())"
      @dbm.query(sql)
    end
  end

  def save_test_run(machine_name)
    # save the test run
    sql = "INSERT INTO scenario_test_runs (scenario_id, test_run_at, test_environment_id,
            browser_id, machine_name, created_at, updated_at)
           VALUES (#{@scenario_id}, now(), #{@env_id}, #{@browser_id}, \'#{machine_name}\', now(), now())"
    @dbm.query(sql)
    @str_id = @dbm.last_id
  end

  # get the step name; keep track of the counter through the scenario
  def get_step_name(scenario)
    @step_counter ||= 0
    step = scenario.steps.to_a[@step_counter]
    @step_counter += 1
    if step == nil
      step
    else
      step.name
    end
  end

  def get_scenario_id(scenario)
    # make sure the scenario title will fit in the database
    trimmed_scenario_title = scenario.title.strip[0...255]
    trimmed_scenario_title = trimmed_scenario_title.gsub('\'', '')

    @scenario_id = 0
    sql = "SELECT id FROM scenarios WHERE scenario_name LIKE \'#{trimmed_scenario_title}\'"
    results = @dbm.query(sql)
    results.each do |r|
      @scenario_id = r["id"]
    end

    # if the scenario isn't in the database, then we need to save it and get its ID
    if @scenario_id == 0
      sql = "INSERT INTO scenarios (scenario_name, created_at, updated_at)
             VALUES (\'#{trimmed_scenario_title}\', now(), now())"
      @dbm.query sql

      @scenario_id = @dbm.last_id
    end
  end

  def get_environment_id
    @env_id = 0
    sql = "SELECT id FROM test_environments WHERE env_name like \'#{TESTENV}\'"
    results = @dbm.query(sql)
    results.each do |r|
      @env_id = r["id"]
    end

    if @env_id == 0
      sql = "INSERT INTO test_environments (env_name, created_at, updated_at) VALUES(\'#{TESTENV}\', now(), now())"
      @dbm.query sql

      @env_id = @dbm.last_id
    end
  end

  def get_browser_id
    @browser_id = 0
    sql = "SELECT id FROM browsers WHERE browser_name like \'#{BROWSER}\'"
    results = @dbm.query(sql)
    results.each do |r|
      @browser_id = r["id"]
    end

    if @browser_id == 0
      sql = "INSERT INTO browsers (browser_name, created_at, updated_at) VALUES(\'#{BROWSER}\', now(), now())"
      @dbm.query sql

      @browser_id = @dbm.last_id
    end
  end

  # save the links for failed scenarios; feature file, scenario, and failed step
  def save_links(scenario)
    failed_step = ""
    ((scenario.instance_eval {@steps}).instance_eval {@steps}).each do |step|
      if step.status == :failed
        failed_step = step.name
      end
    end

    sql = "INSERT INTO scenario_failed_links (scenario_test_run_id, failed_step,
              feature, scenario, scenario_file, created_at, updated_at)
           VALUES(#{@str_id}, \'#{failed_step.gsub('\'', '')}\', \'#{scenario.feature.title.gsub('\'', '')}\',
            \'#{scenario.title.gsub('\'', '')}\', \'#{scenario.feature.file.gsub('\'', '')}\', now(), now())"

    @dbm.query(sql)
  end

  # connect to database with credentials in metrics yml file
  def dbm
    database = OpenStruct.new(YAML.load_file(METRICS_CONFIG_FILE))
    Mysql2::Client.new(:host => database.metrics_db['host'],
                       :username => database.metrics_db['username'],
                       :password => database.metrics_db['password'],
                       :database => database.metrics_db['database'])
  end

  def extract_tags
    @scenario.source_tag_names
  end

end