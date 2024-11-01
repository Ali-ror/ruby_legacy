# == Schema Information
#
# Table name: user_territories
#
#  id                         :integer(4)      not null, primary key
#  user_id                    :integer(4)
#  territory_id               :integer(4)
#  local_admin                :boolean(1)
#  subscribe_email_list       :boolean(1)
#  created_at                 :datetime
#  updated_at                 :datetime
#  subscribe_daily_deal_email :boolean(1)
#

class UserTerritory < ActiveRecord::Base
  belongs_to :user
  belongs_to :territory

  scope :for_territory, lambda { |territory| where( :territory_id => territory.id ) }
    
  attr_accessor :user_proxy, :territory_proxy

  def user_proxy
    user.nil? ? "" : "#{user.to_label} (#{user.email})"
  end
  
  def territory_proxy
    territory.nil? ? "" : "#{territory.description}"
  end

end
