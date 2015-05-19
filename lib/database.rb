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
