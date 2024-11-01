# == Schema Information
#
# Table name: business_listing_categories
#
#  id                  :integer(4)      not null, primary key
#  category_id         :integer(4)
#  business_listing_id :integer(4)
#

require 'spec_helper'

describe BusinessListingCategory do
  should_belong_to :category
  should_belong_to :business_listing
end
