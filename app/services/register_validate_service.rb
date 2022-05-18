class RegisterValidateService

  def initialize(params)
    @params = params
    @validation_errors = []
  end

  def call
    validate_registration_input
    @validation_errors
  end

  private 

  def validate_registration_input
    @validation_errors.push("not valid email") unless ValidationRules.email(@params['email'])
    @validation_errors.push("password is required") unless  ValidationRules.min_length(@params['password'], 1)
    @validation_errors.push("password must be min 8 symbols") unless  ValidationRules.min_length(@params['password'], 8)
    @validation_errors.push("full name is required") unless  ValidationRules.min_length(@params['full_name'], 2)
    @validation_errors.push("passwords didn't match") unless  ValidationRules.matches(@params['password'], @params['password_confirm'])
    @validation_errors.push("email arleady taken") if User::where(email: @params['email']).take
    @validation_errors.push("you had account and it is deactivated") if DeactivatedUser::where(email: @params['email']).take
  end


end
