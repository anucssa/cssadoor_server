require 'active_record'

class Entry < ActiveRecord::Base
  validates :state, presence: true
end

if ENV['RACK_ENV'] == 'production'
  db = URI.parse(ENV['DATABASE_URL'])
elsif ENV['RACK_ENV'] == 'test'
  db = URI.parse('mysql2://localhost/cssadoor_test')
else
  db = URI.parse('mysql2://localhost/cssadoor')
end

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'mysql2' ? 'mysql2' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

