class Todo < ActiveRecord::Base
  attr_reader :id, :title, :label, :deadline, :list_id
end
