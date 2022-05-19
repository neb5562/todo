class TodoController < ApplicationController

  get '/list/:id/new/todo' do
    @chk_list_id = params['id']

    @lists = List::all()

    erb :'todo/new'
  end

  get '/todo/:id/edit' do
    @todo = todo_check(params['id'])

    erb :'todo/edit'
  end

  put '/todo/:id/edit' do
    result = TodoValidateService.new(params).call

    unless result.empty? 
      flash[:error_messages] = result
      redirect("/todo/#{params['id']}/edit")
    else
      TodoUpdateService.new(params, current_user['id']).call 
      flash[:success_message] = 'To Do Updated successfully'
      redirect('/')
    end

  end

  post '/list/:id/new/todo' do
    result = TodoValidateService.new(params, current_user['id']).call
    list_id = params['id']
    unless result.empty? 
      flash[:error_messages] = result
      redirect("/list/#{params['id']}/new/todo")
    else
      TodoService.new(params, list_id, current_user['id']).call 
      flash[:success_message] = 'To Do added successfully'
      redirect('/')
    end
  end

  get '/todo/:id/toggledone' do
    todo_check(params['id'])
    TodoDoneService.new(params, current_user, params['id']).call
    flash[:success_message] = 'To Do done successfully'
    redirect('/')
  end

  delete '/todo/:id/delete' do
    DeleteTodoService.new(params, current_user['id']).call
    flash[:success_message] = 'To Do Deleted successfully'
    redirect('/')
  end


  private 

  def todo_check(todo_id)
    begin
      todo ||= Todo::find(todo_id)
      list ||= current_user.lists.find(todo['list_id'])
      return todo
    rescue ActiveRecord::RecordNotFound
      not_found
    end
  end

  def list_check(id)
    begin
      list ||= current_user.lists.find(id)
      return list
    rescue ActiveRecord::RecordNotFound
      not_found
    end
  end

end
