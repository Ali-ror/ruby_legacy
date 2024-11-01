# == Schema Information
#
# Table name: business_listing_categories
#
#  id                  :integer(4)      not null, primary key
#  category_id         :integer(4)
#  business_listing_id :integer(4)
#

class BusinessListingCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :business_listing
end
