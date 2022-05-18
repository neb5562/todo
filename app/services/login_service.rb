class LoginService

  def initialize(params)
    @params = params
    @user = nil
  end

  def call
    login_user
    return @user['id'] unless @user.nil?
    return nil
  end

  private

  def login_user 
    result = User::find_by(email: @params['email'])
    return nil unless result
    if BCrypt::Password.new(result['password']) == @params['password']
      @user = result
    end
  end

end
