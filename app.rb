require 'sinatra'
require 'sinatra/activerecord'

require 'bundler/setup'
require 'rack-flash'

enable :sessions

use Rack::Flash, :sweep => true

set :database, "sqlite3:my_webapp_database.sqlite3"

require './models'

set :sessions, true

get '/' do
  if current_user
    redirect "/upload"
  else
    erb :signin
  end
end

get'/sign-in' do
  erb :signin
end



post '/' do
  # set @user equal to a user that has the username requested
  # use .first after .where because .where always returns an array,
  # this way you're working with a singular user object
  @user = User.where(username: params[:username]).first
  # first check if a user is returned at all (nil is a 'falsey' value)
  # then check if the user's password is correct
  if @user && @user.password == params[:password]
    # log in the user by setting the session[:user_id] to their ID
    session[:user_id] = @user.id
    # set a flash notice letting the user know that they've logged in successfully
    flash[:notice] = "You've been signed in successfully."
    
  else
    # if the user doesn't exist or their password is wrong, send them a 
    # flash alert saying so
    flash[:alert] = "There was a problem signing you in."
    
  end
  redirect "/"
end

get '/about' do
  erb :about
end


get "/upload" do
  @user= current_user
  @pics = Post.where(user_id: @user.id)
  erb :upload
end

post "/upload" do 
  @user= current_user
  
  File.open('public/' + params[:myfile][:filename], "w") do |f|
    f.write(params[:myfile][:tempfile].read)
  end

  Post.create(image_url: params[:myfile][:filename], caption: params[:mycaption],location: "Brooklyn, NY", user_id: @user.id)
  @pic = 'public/' + params[:myfile][:filename]

  redirect "/upload"
  return "The file was successfully uploaded!"

end

#returs User object if a user is signed in and nil if no user is signed in
def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end