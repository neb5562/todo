class ListValidateService

  def initialize(params, id)
    @params = params
    @user_id = id
    @validation_errors = []
  end

  def call
    validate_list_input
    @validation_errors
  end

  private 

  def validate_list_input
    @validation_errors.push("name is required") unless  ValidationRules.min_length(@params['name'], 1)
    @validation_errors.push("name arleady taken") if List::where(name: @params['name'], user_id: @user_id).take
  end

end
