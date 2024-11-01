class MobileApi::RewardsController < MobileApi::BaseController

  before_filter :set_territory

  def index
    if params[:category]
      @category = Category.find params[:category]
      bl_ids = @category.all_business_listings_with_rewards( @territory.id ).collect { |bl| bl.id }

      @rewards = Reward.unexpired.where( "rewards.business_listing_id IN (?)", bl_ids )
    else
      @rewards = @territory.rewards.active
    end

    @categories = Category.active_categories_with_rewards_for( @territory )

    response = {
                 :categories => @categories.collect { |c| [ c.id, c.name ] },
                 :rewards   => @rewards,
                 :how_it_works => Sanitize.clean( @territory.rewards_text, Sanitize::Config::RESTRICTED )
               }

    respond_with response
  end

  def resellers
    @resellers = @territory.business_listings.resellers.active.collect(&:short_json)
    respond_with @resellers
  end

end

