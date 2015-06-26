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

Gem::Specification.new do |s|
  s.name = 'cucumber-formatter'
  s.version = '1.2.0'
  s.add_runtime_dependency 'mysql2'
  s.date = '2015-06-26'
  s.summary = 'Collect metrics from Cucumber tests'
  s.description = 'Save data collected from Cucumber test to the database'
  s.author = 'Eric Hartill'
  s.email = 'ehartill@salesforce.com'
  s.files = ['lib/cucumber_formatter.rb', 'lib/database.rb', 'lib/failure_rate_module.rb']
  s.homepage = 'https://github.com/SalesforceEng/cucumber-metrics'
  s.license = 'BSD 3-clause'
end