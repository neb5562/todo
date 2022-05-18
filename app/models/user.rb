class User < ActiveRecord::Base
  has_many :todos, dependent: :destroy
  attr_reader :id, :full_name, :email, :password
end
