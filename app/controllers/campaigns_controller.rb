class CampaignsController < ApplicationController
  def index
    @votes = Vote.all
    @campaigns = []

    @votes.map do |vote|
      if !@campaigns.include?(vote.campaign)
        @campaigns << vote.campaign
      end
    end

  end

  def show
    @campaign_votes = Vote.where(campaign: params[:id], validity: 'during')
    @choices = []
    @campaign_votes.map do |vote|
      if !@choices.include?(vote.choice)
        @choices << vote.choice
      end
    end
    @choice_info = []
    for @name in @choices do
      @votes = @campaign_votes.select {|vote| vote.choice == @name}
      @choice_info << {name: @name, votes: @votes.count}
    end
  end

end
