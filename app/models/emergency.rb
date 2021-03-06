class Emergency < ActiveRecord::Base
  EMERGENCY_STATUS_OPEN = "open"
  EMERGENCY_STATUS_CLOSED = "closed"
  validates :date, presence: true
  belongs_to :place
  has_many :companies
  has_many :followups, dependent: :destroy
  accepts_nested_attributes_for :followups
  scope :open, -> { where(status: EMERGENCY_STATUS_OPEN) }
end
