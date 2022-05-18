class TodoService

  def initialize(params, id)
    @params = params
    @user_id = id
  end

  def call
    insert_todo_in_database
  end

  private

  def insert_todo_in_database 
    Todo.create(title: @params['title'], label:  @params['label'], deadline:  @params['deadline'], user_id: @user_id)
  end

end
