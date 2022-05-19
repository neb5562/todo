class User < ActiveRecord::Base
  has_many :lists, dependent: :destroy
  attr_reader :id, :full_name, :email, :password
end
