class LoginValidateService

  def initialize(params)
    @params = params
    @validation_errors = []
  end

  def call
    validate_login_input
    @validation_errors
  end

  private 

  def validate_login_input
    @validation_errors.push("not valid email") unless ValidationRules.email(@params['email'])
    @validation_errors.push("password is required") unless  ValidationRules.min_length(@params['password'], 1)
  end


end
