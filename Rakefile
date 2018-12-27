task default: %w[list_import]

desc "show source names"
task :list_import do
	puts Dir.glob(File.join(__dir__, 'data/source/*.json'))
		.map { |i| File.basename i, '.json' }
		.join("\n")
end

desc "import source by name"
task :import, [:name] do |t, args|
  source_name = args.name

end

namespace :db do
	desc "clean database"
	task :clean do
		require 'yaml'
		require 'sequel'
		require 'database_cleaner'

		config = YAML.load_file File.join(__dir__, 'config/config.yml')
		db = Sequel.connect(config['mysql'])
		DatabaseCleaner[:sequel, {:connection => db}]
		DatabaseCleaner[:sequel].strategy = :truncation
		DatabaseCleaner[:sequel].clean
	end

	desc "load schema"
	task :schema do
		require 'yaml'
		require 'sequel'

		config = YAML.load_file File.join(__dir__, 'config/config.yml')
		db = Sequel.connect(config['mysql'])
		
		db.fetch('SELECT table_name
    		FROM information_schema.tables
    		WHERE table_schema = ?', config['mysql']['database']) do |row|
			db.run('DROP TABLE %s' % row[:table_name])
		end

		schema = File.read(File.join(__dir__, 'data', 'schema.sql'))
		db.run(schema)
	end
end