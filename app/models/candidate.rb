class Candidate < ApplicationRecord
  belongs_to :campaign, foreign_key: :campaign_name
  has_many :votes

  validates_associated :campaign

  def results
    Results.new(self).calculate_votes
  end
end
