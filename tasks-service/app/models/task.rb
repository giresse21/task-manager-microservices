class Task < ApplicationRecord
  validates :title, presence: true
  validates :user_id, presence: true
  validates :project_id, presence: true
  
  # Valeurs par défaut
  after_initialize :set_defaults
  
  private
  
  def set_defaults
    self.completed ||= false
    self.priority ||= 'medium'
  end
end