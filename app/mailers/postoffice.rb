class Postoffice < ActionMailer::Base
  helper
  helper :social_link

  default :from => "updates@relylocal.com"
  if ENV["HOSTNAME"] == "relylocaldev.aghosted.com"
    default_url_options[:host] = "relylocaldev.aghosted.com"
  else
    default_url_options[:host] = "www.relylocal.com"
  end

  def banner_wrong_size( banner, image_size )
    @banner = banner
    @size   = image_size
    @url    = admin_territory_banners_url( banner.territory )
    mail( :to => banner.territory.admin_emails.join(","),
          :subject => "[RelyLocal] Invalid banner dimensions..." )
  end

  def event_created( event )
    @event = event
    @url    = admin_territory_events_url( event.territory )
    mail( :to => event.territory.admin_emails.join(","),
          :subject => "[RelyLocal] New Event Created, awaiting approval..." )
  end

  def mass_email( mass_email, territory )
    @b = mass_email.body
    #Rails.logger.debug "-------------------------------------"
    #Rails.logger.debug territory.business_listings.active.collect(&:user).reject { |u| u.nil? }.collect(&:full_name).flatten.uniq.sort.join(",").inspect
    mail( :from => "RelyLocal - #{territory.name.gsub( ",", "" )} <updates@relylocal.com>",
          :to => "members@relylocal.com",
          :bcc => territory.business_listings.paid_active.collect(&:user).reject { |u| u.nil? }.collect(&:email).flatten.uniq.join(","),
          :subject => mass_email.subject,
          :reply_to => mass_email.reply_to )
  end

  def daily_deal_email( deal, user_territory )
    @deal    = deal
    @ut      = user_territory
    @rewards = user_territory.territory.rewards.active.limit(3)
    mail :from => "RelyLocal - #{user_territory.territory.name.gsub( ",", "" )} <dealoftheday@relylocal.com>",
         :to => user_territory.user.email,
         :subject => "#{@deal.title} from #{@deal.business_listing.name}"
  end

  def listing_requested( business_listing )
    @business_listing = business_listing
    @url = admin_territory_business_listings_url( @business_listing.territory,
                   :protocol => "https",
                   :published => "false" )
    mail :from => "updates@relylocal.com",
         :to => business_listing.territory.admin_emails.join(","),
         :subject => "New Application for #{business_listing.name}"
  end

end
