require 'sinatra'
require 'json'

require_relative 'models'

secret_token = ENV['SECRET_TOKEN']

get('/update_state') do
  puts params
  return 403 if params['token'] != secret_token
  params['state'] == 'open' ? state = 'open' : state = 'closed'
  last = Entry.all.last
  last_state = -> () { last ? last.state : nil }.()
  Entry.create(state: state) unless last_state == state
end

get('/') do
  content_type 'text/json'
  response.headers['Access-Control-Allow-Origin'] = '*'
  current = Entry.all.last
  JSON.generate({state: current ? current.state : 'unknown', since: current.updated_at})
end

get('/history') do
  content_type 'text/json'
  response.headers['Access-Control-Allow-Origin'] = '*'
  history = Entry.all.limit(1000)
  JSON.generate(history.map {|i| {state: i.state, since: i.updated_at} })
end


options('/') do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] =  'Content-Type, Authorization, X-Requested-With'
  response.headers['Access-Control-Max-Age'] = '1000'
  200
end
