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

require 'spec_helper'

describe UserTerritory do
  should_belong_to :user
  should_belong_to :territory
end
