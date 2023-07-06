class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.pluck(:name)
  end

  def show_results
    @campaign = Campaign.find_by(name: params[:campaign])
    if @campaign.present?
      @results = @campaign.candidates.map { |candidate| candidate.results }
      @results = @results.sort
    else
      redirect_to root_path
    end
  end
end
