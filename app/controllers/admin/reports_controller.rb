require 'csv'

class Admin::ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_administrator

  layout "report"


  def territories
    @territories = Territory.all
  end

  def paid_listing_users
    territory = Territory.find params[:territory_id]
    listings  = territory.business_listings.paid_active

    csv_string = CSV.generate do |csv|
      csv << [ "Listing Name", "Expires", "Listing Email" ]
      csv << [ "No active paid listings for #{territory.name}" ] if listings.empty?
      listings.each do |l|
        c = []
        c << l.name
        c << l.expires
        c << l.email
        csv << c
      end
    end

    send_data csv_string,
      :type => 'text/csv; charset=utf-8; header=present',
      :disposition => "attachment; filename=#{territory.name}-paid-listing-emails.csv",
      :filename => "#{territory.name}-paid-listing-emails.csv"
  end

  protected
  
  def validate_administrator
    unless current_user.is_global_admin?
      redirect_to admin_root_path
    end
  end

end