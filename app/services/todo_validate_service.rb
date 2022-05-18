require 'date'
class TodoValidateService

  def initialize(params)
    @params = params
    @validation_errors = []
  end

  def call
    validate_todo_input
    @validation_errors
  end

  private 

  def validate_todo_input
    @validation_errors.push("title is required") unless  ValidationRules.min_length(@params['title'], 1)
    @validation_errors.push("deadline datetime is required") unless  ValidationRules.min_length(@params['deadline'], 1)
    @validation_errors.push("invalid datetime format") unless  valid_date?(@params['deadline'])
  end

  def valid_date?(date)
    date_format = '%d-%m-%Y %H:%M'
    DateTime.strptime(date, date_format)
    true
  rescue ArgumentError
    false
  end

end
