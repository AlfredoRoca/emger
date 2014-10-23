class Emergency < ActiveRecord::Base
  validates :date, presence: true
end
