class DeactivatedUser < ActiveRecord::Base
  attr_reader :id, :full_name, :email, :password
end
