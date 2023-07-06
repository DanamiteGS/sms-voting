class Results
  ResultStruct = Struct.new(:name, :valid_votes, :invalid_votes) do
    def <=>(other)
      # Sort by valid votes in descending order
      comparison = other.valid_votes <=> self.valid_votes

      if comparison.zero? # Ties in valid votes
        # Sort by invalid votes in ascending order (lower invalid votes come first)
        comparison = self.invalid_votes <=> other.invalid_votes
      end

      comparison
    end
  end

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
