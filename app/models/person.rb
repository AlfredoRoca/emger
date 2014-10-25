class Person < ActiveRecord::Base
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :name, presence: true
  validates :lastname, presence: true
end
