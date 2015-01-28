cucumber-metrics
================

A Cucumber formatter that saves long-term data to a database so a team can
review trends in their test runs

WHY?
====

(option one)

This Cucumber formatter saves the data from your test runs to a database. Some
of the metrics are pass/fail, the time the scenario took to run, which tags
are associated with the scenario at the time of the test run, and which browser
and environment were used in the test run.

Once the metrics are in the database, you can pull them out to compare test
runs; you can see if a particular scenario fails more often than others, or
if it's taking longer than it did a month ago. You can query the database
directly, use a script to output it to a csv file, or build a web app to
display the information you want to see.

With this information, you can find problems in your framework that might not
be obvious using reports that only show the results of the last test run.


(option two)

Once a test framework gets to a certain level of complexity, it's very hard to
check each and every scenario to make sure it's still running optimally. At the
same time, the complexity and size means you want each test to run as
efficiently as possible. Imagine running three hundred tests with every build;
how do you know if one is taking 50% more time than it did last month? Or if a
certain step takes twice as long as other steps? If you have intermittent
failures, it's easy to find the scenario that fails every other test run, but
what about one that fails only 15% of the time?

Most reporting formatters for Cucumber concentrate on the last test run,
letting you know which scenarios passed or failed and how much time each
scenario took to complete. This gem takes that data and saves it to a database
so you can go back later and view trends over a period of time. You can query
the database to see which scenarios fail most often. You can see which take the
longest to run. You can create a website to view the data, and create graphs to
show changes in run times. If you test in multiple environments, or run your
tests in staging and production, you can display each environment separately.

In short, this gem gives you the capability to find changing trends in your
tests so you can address them if needed. And that gives you the ability to make
your test suite stronger and more reliable.

HOW?
====

1. Create a metrics.yml file
2. Add the database connection details (host, database, username, password)  
&nbsp;&nbsp;metrics_db:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;database: regressiontests  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;username: username  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;password: userpassword  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;host: db.host.com  
3. Add the following constants to env.rb:  
&nbsp;&nbsp;TESTENV: the environment the tests are running against  
&nbsp;&nbsp;BROWSER: the browser name  
&nbsp;&nbsp;METRICS_CONFIG_FILE: the path to metrics.yml
4. Add the gem to your Gemfile
&nbsp;&nbsp;gem 'cucumber-formatter'
5. Add the formatter to cucumber.yml  
&nbsp;&nbsp;--format CucumberFormatter --out <some_file_name.txt>
6. Create a schema for the database (the file is included in the code)
7. Run your tests

CAVEATS
===

* This formatter is for Cucumber tests written in Ruby
* The formatter requires a MySQL database instance
* It works on my machine ...