class DeleteListService

  def initialize(params, id)
    @params = params
    @id = id
  end

  def call
    delete_list
  end

  private

  def delete_list 
    todo = List.find_by(id: @params['id'], user_id: @id)
    todo.destroy
  end

end
