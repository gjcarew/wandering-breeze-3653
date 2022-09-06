class Project < ApplicationRecord
  validates_presence_of :name, :material
  belongs_to :challenge
  has_many :contestant_projects
  has_many :contestants, through: :contestant_projects

  def theme
    self.challenge.theme
  end

  def avg_contestant_exp
    self.contestants.average(:years_of_experience)
  end
end