class TodoService

  def initialize(params, list_id, user_id)
    @params = params
    @user_id = user_id
    @list_id = list_id
  end

  def call
    insert_todo_in_database
  end

  private

  def insert_todo_in_database 
    Todo.create(title: @params['title'], label:  @params['label'], deadline:  @params['deadline'], list_id: @list_id)
  end

end
