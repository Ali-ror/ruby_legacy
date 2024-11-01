# == Schema Information
#
# Table name: user_daily_deals
#
#  id            :integer(4)      not null, primary key
#  user_id       :integer(4)
#  daily_deal_id :integer(4)
#

class UserDailyDeal < ActiveRecord::Base
  belongs_to :user
  belongs_to :daily_deal
end
