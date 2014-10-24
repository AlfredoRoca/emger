class Scenario < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :description, presence: true
  validates :description, uniqueness: true
end
