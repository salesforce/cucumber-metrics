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

require 'mysql2'

class Database

  def self.query(sql)
    looping = true
    counter = 0
    results = nil

    self.connect

    while looping
      begin
        results = @client.query(sql)
        looping = false
      rescue => e
        counter += 1
        if counter >= 5
          @client.close
          fail "There was an error with the database connection or the query: #{e}"
        end
        sleep 2
        self.connect
      end
    end

    self.disconnect
    results
  end

  private

  def self.connect
    database = OpenStruct.new(YAML.load_file(METRICS_CONFIG_FILE))
    @client = Mysql2::Client.new(:host => database.metrics_db['host'],
                       :username => database.metrics_db['username'],
                       :password => database.metrics_db['password'],
                       :database => database.metrics_db['database'])
  end

  def self.disconnect
    @client.close
  end

end
