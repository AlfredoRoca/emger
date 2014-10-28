class Person < ActiveRecord::Base
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :name, presence: true
  validates :lastname, presence: true
  belongs_to :company
  has_secure_password
end
