class Vote < ApplicationRecord
  belongs_to :campaign, foreign_key: :campaign_name
  belongs_to :candidate

  validates_associated :campaign
  validates_associated :candidate

  TIMELY_VOTES = ['during'].freeze
  INVALID_VOTES = ['pre', 'post'].freeze

  VALIDITY_VALUES = TIMELY_VOTES + INVALID_VOTES

  def self.valid_votes_count
    where(validity: TIMELY_VOTES).count
  end

  def self.invalid_votes_count
    where.not(validity: TIMELY_VOTES).count
  end
end
