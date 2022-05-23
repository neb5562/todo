class DeleteTodoService

  def initialize(params, id)
    @params = params
    @id = id
  end

  def call
    delete_todo
  end

  private

  def delete_todo 
    todo = Todo.find_by(id: @params['id'], user_id: @id)
    todo.destroy
  end

end
