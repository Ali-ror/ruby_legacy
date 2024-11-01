# == Schema Information
#
# Table name: affiliates
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  logo         :string(255)
#  position     :integer(4)
#  territory_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  link         :string(255)
#

class Affiliate < ActiveRecord::Base
  acts_as_list
  
  mount_uploader :logo, LogoUploader

  belongs_to :territory
end
