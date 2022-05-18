class Todo < ActiveRecord::Base
  attr_reader :id, :title, :label, :deadline, :user_id
end
