require "sinatra"
require "yaml"
require "json"
require "puma"
require "sequel"
require "mysql2"

configure do
	set :server, :puma
	set :bind, '0.0.0.0'
	set :port, '7777'
end

get '/accounts/filter/' do
	@config = YAML.load_file File.expand_path('../config.yml', __FILE__)
	@db = Sequel.connect(@config['mysql'])
end

post '/accounts/new/' do
	@config = YAML.load_file File.expand_path('../config.yml', __FILE__)
	@db = Sequel.connect(@config['mysql'])
	
	request.body.rewind
    data = JSON.parse(request.body.read)
    
    return {}
end