class ListController < ApplicationController

  get '/list/new' do
    erb :'list/new'
  end

  get '/list/:id/edit' do
    @list = list_check(params['id'])
    erb :'list/edit'
  end

  put '/list/:id/edit' do
    result = ListValidateService.new(params, current_user['id']).call

    unless result.empty? 
      flash[:error_messages] = result
      redirect("/list/#{params['id']}/edit")
    else
      ListUpdateService.new(params, current_user['id']).call 
      flash[:success_message] = 'List update successfully'
      redirect('/')
    end


    erb :'list/edit'
  end

  delete '/list/:id/delete' do
    DeleteListService.new(params, current_user['id']).call
    flash[:success_message] = 'List Deleted successfully'
    redirect('/')
  end

  get "/list/:id" do
    @page = params['page'].to_i % PER_PAGE_TODO == 0 ? params['page'].to_i : 0
    @list ||= current_user.lists.find_by(id: params['id'])
    @todo ||= logged_in? ? @list.todos.offset(@page).limit(PER_PAGE_TODO).where("deadline > now()").where(is_done: false).order(Arel.sql("is_done desc, (deadline - now()) asc")) : nil
    @count = @list.todos.where("deadline > now()").where(is_done: false).count
    erb :'todo/index'
  end

  get "/list/:id/finished" do
    @page = params['page'].to_i % PER_PAGE_TODO == 0 ? params['page'].to_i : 0
    @list ||= current_user.lists.find_by(id: params['id'])
    @todo ||= logged_in? ? current_user.lists.find_by(id: params['id']).todos.offset(@page).limit(PER_PAGE_TODO).where(is_done: true).order(Arel.sql("is_done desc, (deadline - now()) asc")) : nil
    @count = current_user.lists.find_by(id: params['id']).todos.where(is_done: true).count
    erb :'todo/index'
  end
  
  get "/list/:id/missed" do
    @page = params['page'].to_i % PER_PAGE_TODO == 0 ? params['page'].to_i : 0
    @list ||= current_user.lists.find_by(id: params['id'])
    @todo ||= logged_in? ? current_user.lists.find_by(id: params['id']).todos.offset(@page).limit(PER_PAGE_TODO).where(is_done: false).where("deadline < now()").order(Arel.sql("is_done desc, (deadline - now()) asc")) : nil
    @count = current_user.lists.find_by(id: params['id']).todos.offset(@page).limit(PER_PAGE_TODO).where(is_done: false).where("deadline < now()").count
    erb :'todo/index'
  end

  post '/list' do 
    result = ListValidateService.new(params, current_user['id']).call

    unless result.empty? 
      flash[:error_messages] = result
      redirect('/list/new')
    else
      ListService.new(params, current_user['id']).call 
      flash[:success_message] = 'List added successfully'
      redirect('/')
    end

  end

  private 

  def list_check(id)
    begin
      list ||= current_user.lists.find(id)
      return list
    rescue ActiveRecord::RecordNotFound
      not_found
    end
  end

end
