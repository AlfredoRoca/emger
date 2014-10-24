class Emergency < ActiveRecord::Base
  EMERGENCY_STATUS_OPEN = "open"
  EMERGENCY_STATUS_CLOSED = "closed"
  validates :date, presence: true
end
