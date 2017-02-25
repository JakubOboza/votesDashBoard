class CampaignsController < ApplicationController
def index

  @votes = Vote.all
end

end
