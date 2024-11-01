class RewardsController < ApplicationController
  before_filter :store_location, :only => [:index]

  layout 'application'

  def index
    if !@territory.rewards_enabled
      redirect_to territory_root_path( @territory )
    else
      if params[:categories]
        @category = Category.non_hidden_default_and_territory(@territory).find { |c| c.slugger == params[:categories] }

        bl_ids = @category.all_business_listings_with_rewards( @territory.id ).collect { |bl| bl.id }

        @rewards = Reward.unexpired.where( "rewards.business_listing_id IN (?)", bl_ids )
        @rewards = @rewards.paginate( :per_page => 10, :page => params[:page] || 1 )
      else
        @rewards =  @territory.rewards.active.paginate(:per_page => 10, :page => params[:page] || 1)
      end

      @categories = Category.active_categories_with_rewards_for( @territory )
      @categories = chunk_array( @categories, 3 )

      if @territory.deal_of_the_day_enabled
        @daily_deal = @territory.daily_deals.for_day( Date.today ).first
      end
    end
  end

  def show
    @daily_deal = DailyDeal.find(params[:id])
    render :template => "rewards/show", :layout => "print"
  end

  def all
    @listings = @territory.rewards.active.collect(&:business_listing).uniq
    render :template => "rewards/all", :layout => "rewards"
  end

  def toggle_subscription
    ut = current_user.user_territories.for_territory( @territory ).first
    if ut.subscribe_daily_deal_email.nil? || !ut.subscribe_daily_deal_email
      t = "subscribed"
      ut.subscribe_daily_deal_email = true
    else
      t = "unsubscribed"
      ut.subscribe_daily_deal_email = false
    end

    ut.save( :validate => false )

    flash[:notice] = "You are now #{t} to the Deal of the Day email in #{@territory.name}!"

    redirect_back_or_default( territory_rewards_path( @territory ) )
  end
end
