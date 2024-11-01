# == Schema Information
#
# Table name: comments
#
#  id                  :integer(4)      not null, primary key
#  comment             :text
#  state               :string(255)
#  rating              :integer(4)
#  business_listing_id :integer(4)
#  user_id             :integer(4)
#

require 'spec_helper'

describe Comment do
  should_belong_to :business_listing
  should_belong_to :user

  should_validate_presence_of :comment
  should_validate_presence_of :state
  should_validate_presence_of :rating
  should_validate_presence_of :business_listing_id
  should_validate_presence_of :user_id
end