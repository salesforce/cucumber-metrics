Cucumber Metrics
================

The cucumber-formatter gem is a Cucumber formatter that saves long-term data to
a database so your team can review trends in their test runs.

Why?
====

This enables your team to compare yesterday's test runs to those from a week
or a month ago to see if there is an improvement or degradation in performance.
Data points include passing tests, the time each scenario takes to run, and
which browser was used in the test run.

Once the metrics are in the database, you can get them to compare test runs
using SQL queries, a script to output the information to a csv file, or by
building a web app to read from the database and display it. Then you'll be
able to see if a particular scenario fails more often than others, or if it's
taking longer to run than it did three weeks ago.

With this information, you can find problems in your framework that might not
be obvious using reports that only show the results of the last test run.

How?
====

1. Rename metrics_example.yml to metrics.yml file
2. Update metrics.yml with your credentials
3. Add the following constants to env.rb:  
&nbsp;&nbsp;TESTENV: the environment the tests are running against  
&nbsp;&nbsp;BROWSER: the browser name  
&nbsp;&nbsp;METRICS_CONFIG_FILE: the path to metrics.yml
4. Add the gem to your Gemfile
&nbsp;&nbsp;gem 'cucumber-formatter'
5. Add the formatter to cucumber.yml  
&nbsp;&nbsp;--format CucumberFormatter --out some_file_name.txt
6. Create a schema for the database (the file is included in the code)
7. Run your tests

Caveats
===

* This formatter is for Cucumber tests written in Ruby
* The formatter requires a MySQL database instance
* It works on my machine ...

Bugs and New Features
===

For the latest updates to the gem, follow @desk_dev on Twitter. To report a
bug or request a new feature, create an issue in our github repository:
https://github.com/SalesforceEng/cucumber-metrics/issues

Also check our wiki page for the latest release notes: https://github.com/SalesforceEng/cucumber-metrics/wiki/Release-Notes