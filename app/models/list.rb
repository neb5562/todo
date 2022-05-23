class List < ActiveRecord::Base
  has_many :todos, dependent: :destroy
  attr_reader :id, :name, :user_id
end
