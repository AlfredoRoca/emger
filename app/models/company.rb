class Company < ActiveRecord::Base
  COMPANY_TYPE_FACTORY = 'factory'
  COMPANY_TYPE_PUBLIC = 'public'
  validates :name, presence: true
  validates :name, uniqueness: true
end
