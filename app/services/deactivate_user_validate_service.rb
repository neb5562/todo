class DeactivateUserValidateService

  def initialize(params, user)
    @user = user
    @params = params
    @validation_errors = []
  end

  def call
    validate_deactivate_input
    @validation_errors
  end

  private 

  def validate_deactivate_input
    @validation_errors.push("password is required") unless  ValidationRules.min_length(@params['password'], 1)
    @validation_errors.push("current password is wrong") unless check_current_password
  end

  def check_current_password 
    BCrypt::Password.new(@user['password']) == @params['password']
  end

end
