class ChangeUserService

  def initialize(params, user)
    @user = user
    @params = params
  end

  def call
    update_user_profile_in_database
  end

  private

  def update_user_profile_in_database 
    new_password = BCrypt::Password.create(@params['new_password'])
    user = User.find_by(id: @user['id'])
    user.full_name = @params['full_name'] if @params['full_name'] != user['full_name']
    user.email = @params['email'] if @params['email'] != user['email']
    user.password = new_password unless @params['new_password'].empty?
    user.save
  end

end
