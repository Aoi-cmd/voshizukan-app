require 'sinatra'
require 'sinatra/reloader' if development?
require 'bcrypt'

enable :sessions

# 仮のユーザーデータ
USERS = {
  "testuser" => BCrypt::Password.create("password123")
}

# トップページにアクセスしたとき、ログインページへリダイレクト
get '/' do
  redirect '/login'
end

# ログインフォーム表示
get '/login' do
  erb :login
end

# ログイン処理
post '/login' do
  username = params[:username]
  password = params[:password]

  if USERS[username] && BCrypt::Password.new(USERS[username]) == password
    session[:user] = username
    redirect '/index'
  else
    @error = "ユーザー名またはパスワードが間違っています"
    erb :login
  end
end

# ログイン後のホーム画面
get '/home' do
  redirect '/login' unless session[:user]
  erb :home
end

# ログアウト処理
get '/logout' do
  session.clear
  redirect '/login'
end


set :public_folder, File.dirname(__FILE__)

get '/index' do
  redirect '/login' unless session[:user]
  send_file File.join(settings.public_folder, 'index.html')
end
