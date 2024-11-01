class RewardsCardResellersController < ApplicationController
  before_filter :store_location, :only => [:index]

  def index
    @resellers = @territory.business_listings.resellers.active.shuffle
    @resellers = chunk_array( @resellers, 2 )
  end
end