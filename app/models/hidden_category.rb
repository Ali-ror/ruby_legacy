# == Schema Information
#
# Table name: hidden_categories
#
#  id           :integer(4)      not null, primary key
#  territory_id :integer(4)
#  category_id  :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class HiddenCategory < ActiveRecord::Base
  belongs_to :territory
  belongs_to :category

  scope :for_territory, lambda { |t_id| where(:territory_id => t_id) }
end
