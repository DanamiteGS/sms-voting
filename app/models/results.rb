class Results
  ResultStruct = Struct.new(:name, :valid_votes, :invalid_votes)

  def initialize(votable)
    @votable = votable
    @votes = votable.votes
  end

  def calculate_votes
    valid_votes = @votes.valid_votes_count
    invalid_votes = @votes.count - valid_votes

    ResultStruct.new(@votable.name, valid_votes, invalid_votes)
  end
end
