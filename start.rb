require "sinatra"
require "yaml"
require "puma"
require "sequel"
require "mysql2"

configure do
	set :server, :puma
	set :bind, '0.0.0.0'
	set :port, '7777'
end

get '/accounts/filter' do
	@config = YAML.load_file File.expand_path('../config.yml', __FILE__)
	@db = Sequel.connect(@config['mysql'])
end