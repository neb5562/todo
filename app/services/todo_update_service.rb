class TodoUpdateService

  def initialize(params, user)
    @user = user
    @params = params
  end

  def call
    update_todo
  end

  private

  def update_todo
    todo = Todo.find_by(id: @params['id'], is_done: false)
    todo.title = @params['title']
    todo.label = @params['label']
    todo.list_id = @params['list_id']
    todo.deadline = @params['deadline']
    todo.save
  end

end
