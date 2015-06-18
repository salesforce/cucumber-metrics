/* Copyright (c) 2015, Salesforce.com, Inc.
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
*/

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
  failure_rate int(11) DEFAULT '0',
  PRIMARY KEY (id)
);

CREATE TABLE test_environments (
  id int(11) NOT NULL AUTO_INCREMENT,
  env_name varchar(255) DEFAULT NULL,
  created_at datetime NOT NULL,
  updated_at datetime NOT NULL,
  PRIMARY KEY (id)
);