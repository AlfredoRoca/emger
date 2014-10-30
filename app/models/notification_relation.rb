class NotificationRelation < ActiveRecord::Base
  belongs_to :places
  belongs_to :people
end
