class RegisterService

  def initialize(params)
    @params = params
  end

  def call
    insert_user_in_database
  end

  private

  def insert_user_in_database 
    password = BCrypt::Password.create(@params['password'])
    User.create(full_name: @params['full_name'], email:  @params['email'], password:  password)
  end

end
