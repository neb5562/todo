class ListService

  def initialize(params, id)
    @params = params
    @user_id = id
  end

  def call
    insert_list_in_database
  end

  private

  def insert_list_in_database 
    List.create(name: @params['name'], user_id: @user_id)
  end

end
