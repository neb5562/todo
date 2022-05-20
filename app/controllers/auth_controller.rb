class AuthController < ApplicationController

  include BCrypt

  before do
    if (['/auth/register', '/auth/login'].any? request.path_info) && !session['user_id'].nil?
      redirect('')
    end
  end

  configure do
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "todo"
    register Sinatra::Flash
  end

  get '/auth/login' do
    erb :'auth/login'
  end

  post '/auth/login' do
    result = LoginValidateService.new(params).call
  
    unless result.empty? 
      flash[:error_messages] = result
      redirect('/auth/login')
    end

    user_id = LoginService.new(params).call

    if user_id.nil?
      flash[:error_messages] = ['incorrect email or password']
      redirect('/auth/login')
    else
      session['user_id'] = user_id
      flash[:success_message] = 'Login Successfully'
      redirect('/')
    end

  end

  get '/auth/register' do
    erb :'auth/register'
  end

  post '/auth/register' do
    result = RegisterValidateService.new(params).call
    
    if result.empty? 
      RegisterService.new(params).call 
      flash[:success_message] = 'Registered Successfully, you can login now'
      redirect('/auth/login')
    else
      flash[:error_messages] = result
      redirect('/auth/register')
    end

  end

  get '/auth/log_out' do
    session.clear
    session['user_id'] = nil
    redirect('/')
  end

end

