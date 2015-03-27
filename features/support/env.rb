require 'mysql2'

# BROWSER and TESTENV are required for the gem to work correctly, but
# can be named whatever you want. The values you assign here will be
# saved in the browsers and test_environments tables, respectively. If
# you don't use a browser or environment for your tests, just assign a
# placeholder string to these constants (or leave them as they are).
BROWSER = "firefox"
TESTENV = "staging"
METRICS_CONFIG_FILE = File.expand_path("config/metrics.yml")
