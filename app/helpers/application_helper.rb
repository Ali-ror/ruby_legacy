module ApplicationHelper

  def submit_label( f )
    f.object.new_record? ? "Create" : "Update"
  end

  def available_banners
    banners = Banner::VALID_SIZES.clone
    banners.delete( Banner::VALID_SIZES[0] ) if @territory.banners.narrow.count >= 40
    banners.delete( Banner::VALID_SIZES[1] ) if @territory.banners.wide.count >= 20
    banners
  end

  def territory_navigation?
    if params[:territory_nav]
      return true if params[:territory_nav] == 'true'
    else
      unless @territory.nil? || @territory.new_record? || ( controller_name == "territories" && action_name != "show" )
        return true
      end
    end
    return false
  end

  # Yield helper that also pulls content once (for performance reasons)
  def optional_content(tag, tag_id=nil, &block)
    content = yield
    unless content.blank?
      content_tag(tag.to_sym, content, :id => tag_id || tag.to_s)
    end
  end

  # Business Listing Search Object
  def business_listing_search
    @search || @territory.business_listings.active.search(params[:search])
  end

  def get_banners
    if @territory
      @owner = @territory.business_listings.paid_active.featured_owner.sample
    end

    if @business_listing && controller.controller_name == "business_listings" && @business_listing.show_default_banners_only
      @top_wide     = { :banner => "300x140_default.jpg",         :link => territory_events_path( @territory ),                :target => '' }
      @bottom_wide  = { :banner => "coupon_banner_300x140.jpg",   :link => territory_coupons_path( @territory ),               :target => '' }
      @top_left     = { :banner => "occupy_banner.jpg",           :link => territory_jobs_path(@territory),                    :target => '' }
      @top_right    = { :banner => "140x140_default_2.jpg",       :link => territory_jobs_path(@territory),                    :target => '' }
      @bottom_left  = { :banner => "join_campaign_140x140.jpg",   :link => territory_promote_your_business_path( @territory ), :target => '' }
      @bottom_right = { :banner => "facebook_banner_140x140.jpg", :link => 'https://www.facebook.com/RelyLocalOfficial',       :target => '' }
    else
      @top_wide     = top_wide_banner
      @bottom_wide  = bottom_wide_banner( [ @top_wide ] )

      @top_left     = top_left_small_banner
      @top_right    = top_right_small_banner( [ @top_left ])
      @bottom_left  = bottom_left_small_banner( [ @top_left, @top_right ])
      @bottom_right = bottom_right_small_banner( [ @top_left, @top_right, @bottom_left ])
    end
  end

  def top_left_small_banner
    if @territory
      banner = banner_to_hash( @territory.banners.active.has_location( Banner::LOCATIONS[2] ).sample )
      banner = { :banner => "occupy_banner.jpg", :link => territory_impact_of_local_spending_path( @territory ), :target => '' } if banner.nil?
    else
      banner = { :banner => "national_140x140a.jpg", :link => link_to( "http://www.youtube.com/RelyLocal#p/a/f/0/bXU249fBdoY" ), :target => '' }
    end
    banner
  end

  def top_right_small_banner( banner_collection )
    if @territory
      banner = ( @territory.banners.active.has_location( Banner::LOCATIONS[3] ).map{ |b| banner_to_hash( b ) } - banner_collection ).sample
      banner = { :banner => "140x140_default_2.jpg", :link => territory_jobs_path(@territory), :target => '' } if banner.nil?
    else
      banner = { :banner => "occupy_banner.jpg", :link => occupy_main_street_path, :target => '' }
    end
    banner
  end

  def bottom_left_small_banner( banner_collection )
    if @territory
      banner = ( @territory.banners.active.has_location( Banner::LOCATIONS[4] ).map{ |b| banner_to_hash( b ) } - banner_collection ).sample
      banner = { :banner => "join_campaign_140x140.jpg", :link => territory_promote_your_business_path( @territory ), :target => '' } if banner.nil?
    end
    banner
  end

  def bottom_right_small_banner( banner_collection )
    if @territory
      banner = ( @territory.banners.active.has_location( Banner::LOCATIONS[5] ).map{ |b| banner_to_hash( b ) } - banner_collection ).sample
      banner = { :banner => "facebook_banner_140x140.jpg", :link => 'https://www.facebook.com/RelyLocalOfficial', :target => '' } if banner.nil?
    end
    banner
  end

  def top_wide_banner
    if @territory
      banner = banner_to_hash( @territory.banners.active.has_location( Banner::LOCATIONS[0] ).sample )
      banner = { :banner => "300x140_default.jpg", :link => territory_events_path( @territory ), :target => '' } if banner.nil?
    else
      banner = { :banner => "national_300x140.jpg", :link => link_to( "/page/career_opportunities" ), :target => '' }
    end
    banner
  end

  def bottom_wide_banner( banner_collection )
    if @territory
      banner = ( @territory.banners.active.has_location( Banner::LOCATIONS[1] ).map{ |b| banner_to_hash( b ) } - banner_collection ).sample
      banner = { :banner => "coupon_banner_300x140.jpg", :link => territory_coupons_path( @territory ), :target => '' } if banner.nil?
    end
    banner
  end

  def banner_to_hash( b )
    return nil if b.nil?
    { :banner => b.banner_image_url, :link => b.link, :target => '_blank' }
  end

  def seo_helper
    if @territory
      #Rails.logger.debug "------------------------------------- #{controller.controller_name} - #{controller.action_name}"
      # territory pages
      if controller.controller_name == "pages" && controller.action_name == "home"
        # labeled Local Home Page in requirements
        return ApplicationHelper::SEOLocalHome.new @territory
      elsif controller.controller_name == "pages" && controller.action_name == "sub_page"
        # labeled custom pages in requirements
        return ApplicationHelper::SEOLocalSubPage.new @territory, @sub_page
      elsif controller.controller_name == "business_listings" && controller.action_name == "index"
        # labeled Local Category pages in requirements
        return ApplicationHelper::SEOBusinessListingsIndex.new @territory, @category, @business_listings
      elsif controller.controller_name == "business_listings" && controller.action_name == "show"
        # labeled Local Business Detail Page in requirements
        return ApplicationHelper::SEOBusinessListingsShow.new @territory, @business_listing
      elsif controller.controller_name == "business_listings" && controller.action_name == "search"
        # labeled Search Results in requirements
        return ApplicationHelper::SEOBusinessListingsSearch.new @territory, @search_terms, @business_listings
      else
        # Fallthrough for territory pages
        return ApplicationHelper::SEOTerritoryDefault.new @territory
      end
    else
      #national pages
      if controller.action_name == "occupy_main_street"
        # Occupy main street
        return ApplicationHelper::SEOOccupyMainStreet.new
      elsif controller.controller_name == "cities" && controller.action_name == "index"
        # labeled /{state}/cities page}
        return ApplicationHelper::SEOCitiesIndex.new params[:state]
      else
        return ApplicationHelper::SEONationalDefault.new @territory, @page_title
      end
    end
  end

  class SEOBase
    def initialize( *args )
      @territory = args.first
      @label = PrivateLabel.instance
    end

    def cities
      @territory.cities.collect { |c| c.location }.to_sentence
    end

    def popular_categories
      Category.popular_categories_for( @territory, 6 ).collect { |c| c.name }.to_sentence
    end
  end

  # labeled Local Home Page in requirements
  class SEOLocalHome < ApplicationHelper::SEOBase
    def application_title
      "#{@territory.page_title} : #{@label.site_name}"
    end

    def application_description
      result = ""
      result << @territory.meta_description
      result << " - Support local businesses, find local jobs, and print local coupons!"
      result
    end

    def application_tags
      result = ""
      result << @territory.meta_tags
      result << ", local business directory, local coupons, local internet marketing, local job search, buy local"
      result
    end
  end

  # labeled Custom Pages in requirements
  class SEOLocalSubPage < ApplicationHelper::SEOBase
    def initialize( *args )
      super
      @sub_page = args.last
    end

    def application_title
      "#{@sub_page.page_title} : #{@label.site_name} in #{@territory.name}"
    end

    def application_description
      "#{@sub_page.meta_content_description} : #{@label.site_name} in #{@territory.name}"
    end

    def application_tags
      "#{@sub_page.meta_tags} : #{@label.site_name} in #{@territory.name}"
    end
  end

  # labeled Local Category pages in requirements
  class SEOBusinessListingsIndex < ApplicationHelper::SEOBase
    def initialize( *args )
      super
      @category = args.second
      @business_listings = args.last
    end

    def application_title
      result = ""
      result << @category.name
      result << " in "
      result << @territory.name
      result << " : #{@label.site_name}"
      result
    end

    def application_description
      result = ""
      result << @category.name
      result << " in "
      result << @territory.name
      result << " - featuring: "
      result << first_five_listed_business_names
      result
    end

    def application_tags
      result = ""
      result << @category.name
      result << ", "
      result << first_five_listed_business_names
      result << ", "
      result << self.related_categories
      result
    end

    def first_five_listed_business_names
      @business_listings[0..4].collect { |bl| bl.name }.join( ", " )
    end

    def related_categories
      @category.root.self_and_descendants.collect { |c| c.name }.to_sentence
    end
  end

  # labeled Search Results in requirements
  class SEOBusinessListingsSearch < ApplicationHelper::SEOBase
    def initialize( *args )
      super
      @search = args.second.to_s
      @business_listings = args.last
    end

    def application_title
      result = ""
      result << @search.titlecase
      result << " in "
      result << @territory.name
      if !@business_listings.empty?
        result << " - Try "
        result << @business_listings.first.name
        if @business_listings.length > 1
          result << " or "
          result << (@business_listings.length-1).to_s
          result << " other local businesses"
        end
      end
      result << " : #{@label.site_name}"
      result
    end

    def application_description
      result = ""
      result << "Looking for '"
      result << @search.titlecase
      result << "' in the "
      result << @territory.name
      result << " area? Check out "
      result << first_five_listed_business_names
      result << " - all members of the #{@label.site_name} in "
      result << @territory.name
      result << "!"
      result
    end

    def application_tags
      result = ""
      result << @search
      result << " in "
      result << @territory.name
      result << ", local "
      result << @search.titlecase
      result << ", "
      result << @territory.name
      result << " local businesses, #{@label.site_name} in "
      result << @territory.name
      result
    end

    def first_five_listed_business_names
      @business_listings[0..4].collect { |bl| bl.name }.to_sentence( :last_word_connector => ", or ", :two_words_connector => " or " )
    end

#    def related_categories
#      @category.root.self_and_descendants.collect { |c| c.name }.to_sentence
#    end
  end

  # labeled Local Business Detail Page in requirements
  class SEOBusinessListingsShow < ApplicationHelper::SEOBase
    def initialize( *args )
      super
      @business_listing = args.last
    end

    def application_title
      result = ""
      result << @business_listing.name
      result << " in "
      result << "#{@business_listing.address.city}, #{@business_listing.address.state}"
      result << " : #{@label.site_name}"
      result
    end

    def application_description
      result = ""
      result << @business_listing.name
      result << " in "
      result << "#{@business_listing.address.city}, #{@business_listing.address.state}"
      result << " - "
      result << @business_listing.short_description
      result << " - "
      result << @business_listing.categories.collect { |c| c.name }.join( ', ' )
      #all_related_categories
      result
    end

    def application_tags
      result = ""
      result << ( @business_listing.categories.collect { |c| c.name } + @business_listing.tag_list ).join( ", " )
      result << ", #{@business_listing.name}"
      result << ", Local Businesses in #{@territory.name}"
      result
    end

    def all_related_categories
      results = []
      roots   = []
      #Rails.logger.debug "-------------------------------------"
      @business_listing.categories.each do |c|
        #Rails.logger.debug "------------------------------------- roots"
        #Rails.logger.debug roots.inspect
        if !roots.include?( c.root )
          results << c.root.self_and_descendants.select { |c| ( c.territory_id == @business_listing.territory ) || c.territory_id.nil? }.collect { |c| c.name }.to_sentence
          #Rails.logger.debug "------------------------------------- restuls"
          #Rails.logger.debug results.inspect
          roots << c.root
        end
      end
      results.join( " - " )
    end
  end

  # Fallthrough for territory pages
  class SEOTerritoryDefault < ApplicationHelper::SEOBase
    def application_title
      @territory.page_title.blank? ? @territory.name : @territory.page_title
    end

    def application_description
      @territory.meta_description
    end

    def application_tags
      @territory.meta_tags
    end
  end

  # Fallthrough for national pages
  class SEONationalDefault < ApplicationHelper::SEOBase
    def initialize( *args )
      super
      @page_title = args.last
    end

    def application_title
      "RelyLocal #{(@page_title.blank? ? '' : '| ' + @page_title) }"
    end

    def application_description
      "RelyLocal is a campaign to restore local communities and rebuild local economies by supporting local businesses in hundreds of cities across the America. For consumers, RelyLocal brings a new way to support local business, print local coupons, find local jobs, and connect with their neighbors in a grass-roots effort to stimulate their economy encourage a stronger sense of community. For businesses, RelyLocal offers a unique approach to internet marketing, local search marketing, social media marketing, local seo, coupon marketing, and co-op advertising. It's a revolution!"
    end

    def application_tags
      'rely local, local business, buy local campaign, local companies, local coupons, find local jobs, 3/50 project, relylocal, local search, online coupons, local networking, local first, buy local, business, yellow pages, business opportunities, balle, print local coupons, local business marketing, social media marketing, small business, shop local, online advertising,  local seo, internet marketing,  make local habit, online scams, print coupons, start a business, find a job, relylocal.com'
    end
  end

  # Occupy Main Street SEO
  class SEOOccupyMainStreet < SEONationalDefault
    def initialize( *args )
    end

    def application_title
      "RelyLocal - Make A $20 Shift, Rebuild Your Local Economy"
    end
  end

  # labeled Local Home Page in requirements
  class SEOCitiesIndex < SEONationalDefault
    def initialize( *args )
      @state = args.first
    end

    def application_title
      "RelyLocal Campaigns in #{@state}"
    end

    def application_description
      "#{@state} is full of RelyLocal campaigns across the state. If you are looking for ways to 'buy local' in #{@state}, you can find local coupons from local businesses on RelyLocal.com."
    end
  end


  def hinted_text_field_tag( name, value, hint, options = {} )
    c = value.blank? ? "hint" : ""
    value = value.nil? ? hint : value
    text_field_tag name,
      value,
      { :onclick => "if($(this).val() == '#{hint}'){$(this).val('');$(this).removeClass('hint');}",
        :onfocus => "if($(this).val() == '#{hint}'){$(this).val('');$(this).removeClass('hint');}",
        :onblur => "if($(this).val() == ''){$(this).val('#{hint}');$(this).addClass('hint');}",
        :class => c }.update(options.stringify_keys)
  end

  def hinted_password_field_tag( name, value, hint, options = {} )
    p = password_field_tag name,
      value,
      {
        :style => "display: none",
        :id => "login_password_field",
        :onblur => "hide_password_field()"
      }.update(options.stringify_keys)
    t = text_field_tag "dummy" + name,
      hint,
      {
        :id => "login_password_text_field",
        :onclick => "show_password_field()",
        :onfocus => "show_password_field()",
        :class => "hint"
      }.update(options.stringify_keys)

    p + t
  end

  def admin_link_helper
    if @territory && current_user.is_global_admin?
      link_to "Administration", admin_territory_path( @territory )
    elsif current_user.is_admin?
      link_to "Administration", admin_root_path
    end
  end

end
