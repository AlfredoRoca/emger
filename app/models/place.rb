class Place < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :emergencies, dependent: :destroy
  has_many :notification_relations
  has_many :people, through: :notification_relations
  scope :pinned, -> { where.not(coord_x: nil).where.not(coord_y: nil) }
end
