class ChangeUserValidateService

  def initialize(params, user)
    @user = user
    @params = params
    @validation_errors = []
  end

  def call
    validate_change_user_input
    @validation_errors
  end

  private 

  def validate_change_user_input
    @validation_errors.push("password is required") unless  ValidationRules.min_length(@params['password'], 1)
    @validation_errors.push("Name is required") unless  ValidationRules.min_length(@params['full_name'], 1)
    @validation_errors.push("not valid email") unless ValidationRules.email(@params['email'])
    unless @params['new_password'].empty?
      @validation_errors.push("new password is required") unless  ValidationRules.min_length(@params['new_password'], 1)
      @validation_errors.push("new password confir is required") unless  ValidationRules.min_length(@params['new_password_confirm'], 1)
      @validation_errors.push("password must be min 8 symbols") unless  ValidationRules.min_length(@params['new_password'], 8)
      @validation_errors.push("passwords didn't match") unless  ValidationRules.matches(@params['new_password'], @params['new_password_confirm']) 
      @validation_errors.push("please don't use old password") if  ValidationRules.matches(@params['new_password'], @params['password'])
    end
    @validation_errors.push("current password is wrong") unless check_current_password
  end

  def check_current_password 
    BCrypt::Password.new(@user['password']) == @params['password']
  end

end
