# == Schema Information
#
# Table name: categories
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  parent_id       :integer(4)
#  lft             :integer(4)
#  rgt             :integer(4)
#  territory_id    :integer(4)
#  path_name_cache :string(255)
#

require 'spec_helper'

describe Category do
  should_belong_to :territory

  should_have_many :business_listing_categories,
                   :dependent => :destroy

  should_have_many :business_listings,
                   :through => :business_listing_categories
end
