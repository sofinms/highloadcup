require "sinatra"
require "yaml"
require "json"
require "puma"
require "sequel"
require "mysql2"
require "sinatra/json"

CONFIG = YAML.load_file File.join(__dir__, 'config/config.yml')
DB = Sequel.connect(CONFIG['mysql'], max_connections: 50, preconnect: :concurrently)

configure do
	set :server, :puma
	set :bind, '0.0.0.0'
	set :port, '7777'
end

get '/accounts/filter/' do
	error 501
end

post '/accounts/new/' do
	request.body.rewind
    account = JSON.parse(request.body.read)
    begin
	    DB.transaction do
		    
	# 	    DB.run("INSERT INTO accounts (id, email, fname, sname, phone, sex, birth, country, city, joined, status) VALUES (?,?,?,?,?,?,?,?,?,?,?)", [account["id"], account["email"], account["fname"], account["sname"], account["phone"], account["sex"], account["birth"], account["country"], account["city"], account["joined"], account["status"]])
			DB[:accounts].insert('id' => account["id"], 'email' => account["email"], 'fname' => account["fname"], 'sname' => account["sname"], 'phone' => account["phone"], 'sex' => account["sex"], 'birth' => account["birth"], 'country' => account["country"], 'city' => account["city"], 'joined' => account["joined"], 'status' => account["status"])
			if account['likes']
			    account['likes'].each do |like|
		# 			DB.run("INSERT INTO account_likes (id, from_account_id, ts) VALUES (?,?,?)", like["id"], account["id"], like["ts"])
					DB[:account_likes].insert('id' => like["id"], 'from_account_id' => account["id"], 'ts' => like["ts"])
				end
			end
			if account['interests']
				account['interests'].each do |interest|
					interest_id = DB["SELECT id FROM interests WHERE value LIKE ?", interest].first[:id] rescue nil
					if interest_id.nil?
		# 				interest_id = DB.run("INSERT INTO interests (value) VALUES (?)", interest)
						interest_id = DB[:interests].insert('value' => interest)
					end
		# 			DB.run("INSERT INTO account_interests (account_id, interest_id) VALUES (?,?)", account["id"], interest_id)
					DB[:account_interests].insert('account_id' => account["id"], 'interest_id' => interest_id)
				end
			end
	    end
    rescue Sequel::UniqueConstraintViolation
		DB.disconnect
		status 400
		content_type :json
		return {}.to_json
		
	rescue
		DB.disconnect
		status 400
		content_type :json
		return {}.to_json
	end
    DB.disconnect

    status 200
	content_type :json
	return {}.to_json
end


post '/accounts/:id/' do
	request.body.rewind
	begin
	    account = JSON.parse(request.body.read)
	    account_id = DB["SELECT id FROM accounts WHERE id = ?", params['id']].first[:id] rescue nil
	    if account_id == nil
		    DB.disconnect
			status 404
			content_type :json
			return {}.to_json
		end
	
		interests = nil
		likes = nil
		if account.key?("interests")
			interests = account['interests']
			account.delete('interests')
		end
		if account.key?("likes")
			likes = account['likes']
			account.delete('likes')
		end
		DB[:accounts].where(:id => params['id']).update(account)
		if interests
			DB[:account_interests].where(:account_id => params['id']).delete
			interests.each do |interest|
				interest_id = DB["SELECT id FROM interests WHERE value LIKE ?", interest].first[:id] rescue nil
				if interest_id.nil?
					interest_id = DB[:interests].insert('value' => interest)
				end
				DB[:account_interests].insert('account_id' => params["id"], 'interest_id' => interest_id)
			end
		end
		if likes
			DB[:account_likes].where(:from_account_id => params["id"]).delete
			likes.each do |like|
				DB[:account_likes].insert('id' => like["id"], 'from_account_id' => params["id"], 'ts' => like["ts"])
			end
		end
	rescue
		DB.disconnect
		status 400
		content_type :json
		return {}.to_json
	end
    DB.disconnect

    status 200
	content_type :json
	return {}.to_json
end

post '/accounts/likes/' do
	request.body.rewind
	begin
    	likes = JSON.parse(request.body.read)
    	DB.transaction do
			likes['likes'].each do |like|
		    	if like.keys.count != 3 or !like.key?("likee") or !like.key?("ts") or !like.key?("liker")
			    	DB.disconnect
					status 400
					content_type :json
					return {}.to_json
			    end
			    DB[:account_likes].insert('id' => like["likee"], 'from_account_id' => like["liker"], 'ts' => like["ts"])
		    end
		end
    rescue
    	DB.disconnect
		status 400
		content_type :json
		return {}.to_json
    end
end