require "./config/environment"
require 'date'
require 'cgi'

class ApplicationController < Sinatra::Base
  PER_PAGE_LIST = 6
  PER_PAGE_TODO = 6
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "todo"
    register Sinatra::Flash
  end

  get "/" do
    @page = params['page'].to_i % PER_PAGE_LIST == 0 ? params['page'].to_i : 0
    @list ||= logged_in? ? current_user.lists.offset(@page).limit(PER_PAGE_LIST).order('created_at desc') : nil
    @count = current_user.lists.count
    erb :'list/index'
  end

  def logged_in?
    !!current_user
  end
  
  def current_user
    @current_user ||= User.find(session['user_id']) if session['user_id']
  end

  not_found do
    status 404
    erb :'404'
  end

  def h(html)
    CGI.escapeHTML html
  end
  
end
