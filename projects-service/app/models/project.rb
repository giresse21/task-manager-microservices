class Project < ApplicationRecord
  validates :name, presence: true
  validates :user_id, presence: true
  
  # Pas de belongs_to :user car le user est dans un autre service !
  # On stocke juste le user_id
end