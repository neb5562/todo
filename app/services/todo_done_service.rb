class TodoDoneService

  def initialize(params, user, id)
    @user = user
    @params = params
    @id = id
  end

  def call
    update_todo_done
  end

  private

  def update_todo_done
    todo = Todo.find_by(id: @id, user_id: @user['id'])
    todo.is_done = !todo.is_done
    todo.save
  end

end
