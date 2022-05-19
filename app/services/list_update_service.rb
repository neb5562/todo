class ListUpdateService

  def initialize(params, user_id)
    @user_id = user_id
    @params = params
  end

  def call
    update_list
  end

  private

  def update_list
    list = List.find_by(id: @params['id'], user_id: @user_id)
    list.name = @params['name']
    list.save
  end

end
