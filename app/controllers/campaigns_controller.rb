class CampaignsController < ApplicationController

  def index
    votes = Vote.all
    @campaigns = []
    votes.map { |vote| @campaigns << vote.campaign if !@campaigns.include?(vote.campaign)}
  end

  def show
    @campaign_votes = Vote.where(campaign: params[:id], validity: 'during')
    @choice_info = derive_data_to_show_from @campaign_votes
  end


  private

  def derive_data_to_show_from campaign_votes
    choices = get_possible_choices(campaign_votes)
    create_info_for(choices, campaign_votes)
  end

  def get_possible_choices campaign_votes
    choices = []
    campaign_votes.map { |vote| choices << vote.choice if !choices.include?(vote.choice)}
    choices
  end

  def create_info_for (choices, campaign_votes)
    choice_info = []
    for name in choices do
      votes_per_choice = campaign_votes.select { |vote| vote.choice == name }
      percentage = (votes_per_choice.count * 100) / campaign_votes.count
      choice_info << {name: name, votes: votes_per_choice.count, percentage: percentage }
    end
    choice_info
  end

end
