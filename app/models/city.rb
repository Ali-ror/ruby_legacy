# == Schema Information
#
# Table name: cities
#
#  id           :integer(4)      not null, primary key
#  city         :string(255)
#  state        :string(255)
#  territory_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  cached_slug  :string(255)
#

class City < ActiveRecord::Base
  belongs_to :territory
    
  validates :city,  :presence => true
  validates :state, :presence => true
  
  scope :with_territory,    where("territory_id IS NOT ?", nil)
  
  def location
    "#{city}, #{state}"
  end
end
