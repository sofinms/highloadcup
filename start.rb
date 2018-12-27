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
    account = JSON.parse(request.body.read)
    @db.transaction do
	    
# 	    @db.run("INSERT INTO accounts (id, email, fname, sname, phone, sex, birth, country, city, joined, status) VALUES (?,?,?,?,?,?,?,?,?,?,?)", [account["id"], account["email"], account["fname"], account["sname"], account["phone"], account["sex"], account["birth"], account["country"], account["city"], account["joined"], account["status"]])
	@db[:accounts].insert('id' => account["id"], 'email' => account["email"], 'fname' => account["fname"], 'sname' => account["sname"], 'phone' => account["phone"], 'sex' => account["sex"], 'birth' => account["birth"], 'country' => account["country"], 'city' => account["city"], 'joined' => account["joined"], 'status' => account["status"])
	    if account['likes']
		    account['likes'].each do |like|
	# 			@db.run("INSERT INTO account_likes (id, from_account_id, ts) VALUES (?,?,?)", like["id"], account["id"], like["ts"])
				@db[:account_likes].insert('id' => like["id"], 'from_account_id' => account["id"], 'ts' => like["ts"])
			end
		end
		if account['interests']
			account['interests'].each do |interest|
				interest_id = @db["SELECT id FROM interests WHERE value LIKE ?", interest].first[:id] rescue nil
				if interest_id.nil?
	# 				interest_id = @db.run("INSERT INTO interests (value) VALUES (?)", interest)
					interest_id = @db[:interests].insert('value' => interest)
				end
	# 			@db.run("INSERT INTO account_interests (account_id, interest_id) VALUES (?,?)", account["id"], interest_id)
				@db[:account_interests].insert('account_id' => account["id"], 'interest_id' => interest_id)
			end
		end
    end
    @db.disconnect

    return {}
end