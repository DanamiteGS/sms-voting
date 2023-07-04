class Campaign < ApplicationRecord
  self.primary_key = :name

  has_many :candidates, primary_key: :name, foreign_key: :campaign_name
  has_many :votes, primary_key: :name, foreign_key: :campaign_name
  
  def results
    Results.new(self).calculate_votes
  end
end
