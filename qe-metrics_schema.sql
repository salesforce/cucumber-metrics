CREATE TABLE browsers (
  id int(11) NOT NULL AUTO_INCREMENT,
  browser_name varchar(255) DEFAULT NULL,
  created_at datetime NOT NULL,
  updated_at datetime NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE scenario_failed_info (
  id int(11) NOT NULL AUTO_INCREMENT,
  scenario_test_run_id int(11) DEFAULT NULL,
  failed_step varchar(255) DEFAULT NULL,
  feature varchar(255) DEFAULT NULL,
  scenario varchar(255) DEFAULT NULL,
  scenario_file varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE scenario_failed_links (
  id int(11) NOT NULL AUTO_INCREMENT,
  scenario_test_run_id int(11) DEFAULT NULL,
  failed_step varchar(255) DEFAULT NULL,
  feature varchar(255) DEFAULT NULL,
  scenario varchar(255) DEFAULT NULL,
  scenario_file varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE scenario_steps (
  id int(11) NOT NULL AUTO_INCREMENT,
  elapsed_time int(11) DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  scenario_test_run_id int(11) DEFAULT NULL,
  created_at datetime NOT NULL,
  updated_at datetime NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE scenario_tags (
  id int(11) NOT NULL AUTO_INCREMENT,
  scenario_test_run_id int(11) DEFAULT NULL,
  tag_name varchar(255) DEFAULT NULL,
  created_at datetime NOT NULL,
  updated_at datetime NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE scenario_test_runs (
  id int(11) NOT NULL AUTO_INCREMENT,
  elapsed_time int(11) DEFAULT NULL,
  test_environment_id int(11) DEFAULT NULL,
  passed tinyint(1),
  scenario_id int(11) DEFAULT NULL,
  test_run_at datetime DEFAULT NULL,
  site_url varchar(255) DEFAULT NULL,
  time_to_registered time DEFAULT NULL,
  browser_id int(11) DEFAULT NULL,
  browser_version varchar(255) DEFAULT NULL,
  machine_name varchar(255) DEFAULT NULL,
  created_at datetime NOT NULL,
  updated_at datetime NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE scenarios (
  id int(11) NOT NULL AUTO_INCREMENT,
  scenario_name varchar(255) DEFAULT NULL,
  created_at datetime NOT NULL,
  updated_at datetime NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE test_environments (
  id int(11) NOT NULL AUTO_INCREMENT,
  env_name varchar(255) DEFAULT NULL,
  created_at datetime NOT NULL,
  updated_at datetime NOT NULL,
  PRIMARY KEY (id)
);