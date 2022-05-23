require "./config/environment"
require 'date'
require 'cgi'
require "rack/csrf"

class ApplicationController < Sinatra::Base
  PER_PAGE_LIST = 6
  PER_PAGE_TODO = 6

  before do
    if (['/auth/register', '/auth/login'].any? request.path_info) && !session['user_id'].nil?
      redirect('/')
    end

    if (['/auth/register', '/auth/login'].none? request.path_info) && session['user_id'].nil?
      redirect('/auth/login')
    end
  end

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "asdfkbdasf$%^TE%&R%ERUFDSGDewrtuoi"
    register Sinatra::Flash
    # use Rack::Session::Cookie, :secret => "asdfkbdasf$%^TE%&R%ERUFDSGDewrtuoi"
    use Rack::Csrf, :raise => true
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

  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end
  
end
