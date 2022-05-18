class DeactivateUserService

  def initialize(params, user)
    @user = user
    @params = params
  end

  def call
    deactivate_user
  end

  private

  def deactivate_user 
    password = BCrypt::Password.create(@params['password'])

    ActiveRecord::Base.transaction do
      user = User.find_by(id: @user['id'])
      new_user = DeactivatedUser.create(full_name: user['full_name'], email:  user['email'], password:  user['password'])
      user.destroy
    end

  end

end
