require 'rubygems'
require 'sinatra'
require 'haml'
require 'active_record'

# Enable sinatra sessions
set :sessions, true

# Connect to SQLite Database
load 'db_connect.rb'

# Sinatra helpers
load 'helpers.rb'

# Load models
load 'models/Login.rb'
load 'models/Post.rb'


# -------------------------------------------
# -------------------------------------------
# LOGIN
get '/' do
	if session[:user] == nil
		haml :index
	else
		redirect '/posts'
	end
end

get '/loginerror' do
	if session[:user] == nil
		haml :index_error
	else
		redirect '/posts'
	end
end

post '/login' do
	@logins = Login.count(:conditions => ['user = ? AND password = ?', params[:user], params[:password]])
	
	if @logins == 0
		redirect '/loginerror'
	else
		session[:user] = params[:user]
		redirect '/posts'
	end
end

post '/logout' do
	session[:user] = nil
	redirect '/'
end

# -------------------------------------------
# -------------------------------------------
# POSTS
get '/posts' do
	if session[:user] == nil
		redirect '/'
	else
		haml :post
	end
end

get '/posts/create' do
	if session[:user] == nil
		redirect '/'
	else
		haml :postnew
	end
end

post '/posts/new' do
	@posts = Post.create(params[:posts])

	if session[:user] == nil
		redirect '/'
	else
		@posts.save
		redirect '/posts/manage'
	end
end

get '/posts/manage' do
	@posts = Post.all()
	haml :postmanage
end

get '/posts/manage/show/:id' do
	@posts = Post.find(params[:id])
	haml :postmanageshow
end

get '/posts/manage/delete/:id' do
	@posts = Post.find(params[:id])

	if session[:user] == nil
		redirect '/'
	else
		@posts.destroy
		redirect '/posts/manage'
	end
end

get '/posts/manage/edit/:id' do
	@posts = Post.find(params[:id])
	haml :postmanageedit
end

post '/posts/manage/update/:id' do
	@posts = Post.find(params[:id])
	
	if session[:user] == nil
		redirect '/'

	else 
		@posts.update(params[:posts])
		redirect '/posts/manage'
	end
end
