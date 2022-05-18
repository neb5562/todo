require "./config/environment"
require 'date'
require 'cgi'

class ApplicationController < Sinatra::Base
  PER_PAGE = 6

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "todo"
    register Sinatra::Flash
  end

  get "/" do
    @page = params['page'].to_i % PER_PAGE == 0 ? params['page'].to_i : 0
    @list ||= logged_in? ? current_user.todos.offset(@page).limit(PER_PAGE).where("deadline > now()").where(is_done: false).order(Arel.sql("is_done desc, (deadline - now()) asc")) : nil
    @count = current_user.todos.where("deadline > now()").where(is_done: false).count
    erb :'list/index'
  end

  get "/finished" do
    @page = params['page'].to_i % PER_PAGE == 0 ? params['page'].to_i : 0
    @list ||= logged_in? ? current_user.todos.offset(@page).limit(PER_PAGE).where(is_done: true).order(Arel.sql("is_done desc, (deadline - now()) asc")) : nil
    @count = current_user.todos.where(is_done: true).count
    erb :'list/index'
  end
  
  get "/missed" do
    @page = params['page'].to_i % PER_PAGE == 0 ? params['page'].to_i : 0
    @list ||= logged_in? ? current_user.todos.offset(@page).limit(PER_PAGE).where(is_done: false).where("deadline < now()").order(Arel.sql("is_done desc, (deadline - now()) asc")) : nil
    @count = current_user.todos.offset(@page).limit(PER_PAGE).where(is_done: false).where("deadline < now()").count
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
