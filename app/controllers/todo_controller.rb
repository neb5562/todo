class TodoController < ApplicationController

  get '/todo/new' do
    erb :'list/new'
  end

  get '/todo/:id/edit' do
    @todo = todo_check(params['id'])

    erb :'list/edit'
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

  post '/todo' do
    result = TodoValidateService.new(params).call

    unless result.empty? 
      flash[:error_messages] = result
      redirect('/todo/new')
    else
      TodoService.new(params, current_user['id']).call 
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

  def todo_check(id)
    begin
      todo ||= Todo.find(id)
      return todo
    rescue ActiveRecord::RecordNotFound
      not_found
    end
  end

end
