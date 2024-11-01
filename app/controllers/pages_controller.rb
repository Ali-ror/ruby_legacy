require 'open-uri'
require 'json'

class PagesController < ApplicationController
  before_filter :store_location, :only => [:home]

  def home
    @title = "home"
    if @territory
      @recent_listings   = @territory.business_listings.paid_or_feeder_active.includes( :slugs ).includes( :coupons ).includes(:comments ).recent.limit(8).reorder("created_at DESC")
      @featured_listings = @territory.business_listings.active.featured.includes( :slugs ).includes( :address ).includes( :comments ).shuffle
      @featured_listings = @featured_listings.slice(0..7) if @featured_listings.length > 8
      @coupons           = @territory.paid_active_coupons.limit(12)
      @daily_deal        = @territory.daily_deals.for_day( Date.today ).first if @territory.deal_of_the_day_enabled
      @rewards           = @territory.paid_active_rewards.limit(8)
    end
  end

  def national
    @page_title =  "Community Campaigns to Stimulate Local Economies"
    @title, @national = "home", true
    respond_to do |format|
      format.html do
        begin
          territory_id = get_stored_territory_id
          if !territory_id.blank? && !request.path.include?("/national")
            redirect_to territory_root_path( Territory.find( territory_id ) )
          end
        rescue ActiveRecord::RecordNotFound
          return true
        end
      end
      format.plain { render :template => "/pages/_national_form.html",
                            :locals => { :display_inline => true },
                            :layout => false }
    end
  end

  def jobs
    @city = @territory.cities.first
    @start = params.has_key?( :start ) ? params[:start].to_i : 0

    #Rails.logger.debug @start.inspect

    user_agent = request.env['HTTP_USER_AGENT']
    user_ip    = request.remote_ip
    place      = "#{@city.city}, #{@city.state}"

    api_url = URI::escape "http://api.indeed.com/ads/apisearch?publisher=3041400695423329&format=json&v=2&radius=20&limit=20&l=#{place}&userip=#{user_ip}&useragent=#{user_agent}&start=#{@start}"

    #Rails.logger.debug "-------------------------------------"
    #Rails.logger.debug api_url.inspect

    @jobs = JSON.parse( open( api_url ).read )
    #Rails.logger.debug "-------------------------------------"
    #Rails.logger.debug @jobs.inspect
  end

  def rl_careers
    @page_title = "Careers"
  end

  def page
    if params && params[:page]
      @page_title = "#{params[:page].titlecase} | Community Campaigns to Stimulate Local Economies"
      render :template => "/pages/static/#{params[:page].gsub('-','_')}"
    end
  end

  def sub_page
    if params && params[:sub_page] != "business_listings" && params[:sub_page] != "galleryview" && params[:sub_page] != "facebook"
      begin
        @sub_page   = SubPage.find(params[:sub_page])
        @page_title = @sub_page.page_title
      rescue
        redirect_to :action => :home
      end
    end
  end

  def rewards
    @page_title =  "Community Campaigns to Stimulate Local Economies"
    respond_to do |format|
      format.html do
        begin
          @title, @national = "home", true
          territory_id = get_stored_territory_id
          if !territory_id.blank?
            redirect_to territory_rewards_path( Territory.find( territory_id ) )
          end
        rescue ActiveRecord::RecordNotFound
          return true
        end
      end
    end
  end

end
