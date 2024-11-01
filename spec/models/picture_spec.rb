# == Schema Information
#
# Table name: pictures
#
#  id                  :integer(4)      not null, primary key
#  caption             :string(255)
#  business_listing_id :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  picture             :string(255)
#  state               :string(255)
#

require 'spec_helper'

describe Picture do
  should_belong_to :business_listing
  
  should_validate_presence_of :state
  should_validate_presence_of :picture  
end
