class Candidate < ApplicationRecord
  belongs_to :campaign, foreign_key: :campaign_name
  has_many :votes

  validates_associated :campaign
end
