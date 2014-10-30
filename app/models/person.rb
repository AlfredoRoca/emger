class Person < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :name, presence: true
  validates :lastname, presence: true
  belongs_to :company
  has_many :places, through: :notification_relations
  has_many :notification_relations

end
