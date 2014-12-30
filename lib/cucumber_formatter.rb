class CucumberFormatter

  def initialize(step_mother, io, options)
    puts "Initializing CucumberMetrics ...\n\n\n"
  end

  def before_feature_element(scenario)
    @scenario = scenario
    @scenario_time_start = Time.now

    @start_time = Time.now
    @end_time = Time.now
    machine_name = Socket.gethostname

    @dbm ||= dbm

    if scenario == nil
      fail "The scenario did not run"
    end

    get_scenario_id(scenario)
    get_environment_id
    get_browser_id

    # save the test run
    sql = "INSERT INTO m_scenario_test_runs (scenario_id, test_run_at, test_environment_id, browser_id, machine_name) VALUES (#{@scenario_id}, now(), #{@env_id}, #{@browser_id}, \'#{machine_name}\')"
    @dbm.query(sql)
    @str_id = @dbm.last_id

    # extract and save the tags
    tags = extract_tags(scenario)
    tags.each do |t|
      sql = "INSERT INTO m_scenario_tags (scenario_test_run_id, tag_name) VALUES (#{@str_id}, \'#{t}\')"
      @dbm.query(sql)
    end
  end

  def after_step(step)
    step_name = get_step_name(@scenario).strip[0..255].gsub('\'', '')
    @start_time = @end_time
    @end_time = Time.now

    sql = "INSERT INTO m_scenario_steps (scenario_test_run_id, name, elapsed_time) VALUES (#{@str_id}, \'#{step_name}\', #{(@end_time - @start_time).round})"
    @dbm.query sql
  end

  def after_feature_element(scenario)
    scenario.failed? ? passed = 0 : passed = 1

    sql = "UPDATE m_scenario_test_runs SET elapsed_time = #{Time.now - @scenario_time_start}, passed = #{passed} WHERE id = #{@str_id}"
    @dbm.query sql

    if scenario.failed?
      save_links(scenario)
    end
    @step_counter = 0
  end

  private

  def get_step_name(scenario)
    @step_counter ||= 0
    steps = scenario.instance_eval {@steps}
    step_name = (steps.instance_eval {@steps})[@step_counter]
    @step_counter += 1
    return step_name.name
  end

  def get_scenario_id(scenario)
    # make sure the scenario title will fit in the database
    trimmed_scenario_title = scenario.title.strip[0...255]
    trimmed_scenario_title = trimmed_scenario_title.gsub('\'', '')

    @scenario_id = 0
    sql = "SELECT id FROM m_scenarios WHERE scenario_name LIKE \'#{trimmed_scenario_title}\'"
    results = @dbm.query(sql)
    results.each do |r|
      @scenario_id = r["id"]
    end

    # if the scenario isn't in the database, then we need to save it and get its ID
    if @scenario_id == 0
      sql = "INSERT INTO m_scenarios (scenario_name) VALUES (\'#{trimmed_scenario_title}\')"
      @dbm.query sql

      @scenario_id = @dbm.last_id
    end
  end

  def get_environment_id
    @env_id = 0
    sql = "SELECT id FROM m_test_environments WHERE env_name like \'#{TESTENV}\'"
    results = @dbm.query(sql)
    results.each do |r|
      @env_id = r["id"]
    end

    if @env_id == 0
      sql = "INSERT INTO m_test_environments (env_name) VALUES(\'#{TESTENV}\')"
      @dbm.query sql

      @env_id = @dbm.last_id
    end
  end

  def get_browser_id
    @browser_id = 0
    sql = "SELECT id FROM m_browsers WHERE browser_name like \'#{BROWSER}\'"
    results = @dbm.query(sql)
    results.each do |r|
      @browser_id = r["id"]
    end

    if @browser_id == 0
      sql = "INSERT INTO m_browsers (browser_name) VALUES(\'#{BROWSER}\')"
      @dbm.query sql

      @browser_id = @dbm.last_id
    end
  end

  def save_links(scenario)
    failed_step = ""
    ((scenario.instance_eval {@steps}).instance_eval {@steps}).each do |step|
      if step.status == :failed
        failed_step = step.name
      end
    end

    sql = "INSERT INTO m_scenario_failed_info (scenario_test_run_id, failed_step, feature, scenario, scenario_file)
            VALUES(#{@str_id}, \'#{failed_step.gsub('\'', '')}\', \'#{scenario.feature.title.gsub('\'', '')}\',
            \'#{scenario.title.gsub('\'', '')}\', \'#{scenario.feature.file.gsub('\'', '')}\')"

    @dbm.query(sql)
  end

  def dbm
    database = OpenStruct.new(YAML.load_file(METRICS_CONFIG_FILE))
    Mysql2::Client.new(:host => database.metrics_db['host'],
                       :username => database.metrics_db['username'],
                       :password => database.metrics_db['password'],
                       :database => database.metrics_db['database'])
  end

  def extract_tags(scenario)
    # blog post explaining instance_eval:
    # http://jamescrisp.org/2009/08/05/spying-on-instance-variables-in-ruby/

    # first, get the tags from the feature and from the scenario. #instance_eval allows
    # us to get instance variables that don't have accessors.
    feature_tags = scenario.feature.instance_eval {@tags}
    scenario_tags = scenario.instance_eval {@tags}

    # the method #to_sexp is defined in Cucumber::Ast::Tags; it returns
    # the tags as an array of arrays
    feature_tags = feature_tags.to_sexp
    scenario_tags = scenario_tags.to_sexp
    # combine all these arrays into foo. This gives you double arrays; a symbol and a string for each tag
    feature_tags = feature_tags.concat(scenario_tags).flatten.compact
    # loop through the array and if the element is a string, add it to a new array - these are the tags as strings
    all_tags = Array.new
    feature_tags.each do |f|
      if f.class == String and f != "@gui"
        all_tags << f
      end
    end
    return all_tags
  end

end