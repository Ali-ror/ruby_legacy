module TerritoryHelper

  def get_summary_count( model )
    data = @territory.business_listings.includes( model ).collect { |bl| eval( "bl.#{model.to_s}" ) }
    #p data
    a = data.inject( 0 ) { |sum, m| sum + m.length }
    b = data.inject( 0 ) { |sum, m| sum + m.select { |a_m| a_m.state == BusinessListing::APPROVED }.length }
    c = data.inject( 0 ) { |sum, m| sum + m.select { |a_m| a_m.state == BusinessListing::REJECTED }.length }
    d = data.inject( 0 ) { |sum, m| sum + m.select { |a_m| a_m.state == BusinessListing::PENDING }.length }

    [ a, b, c, d ]
  end

  def get_expiring_coupon_count
    bl_ids = @territory.business_listings.collect { |bl| bl.id }
    data = Coupon.expiring_in_30_days.where( "business_listing_id IN (?)", bl_ids )
    data.length
  end

  def get_expiring_rewards_count
    bl_ids = @territory.business_listings.collect { |bl| bl.id }
    data = Reward.expiring_in_30_days.where( "business_listing_id IN (?)", bl_ids )
    data.length
  end

end
