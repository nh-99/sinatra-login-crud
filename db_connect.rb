ActiveRecord::Base.establish_connection(
	:adapter => 'sqlite3',
	:database => 'data/app.db'
)