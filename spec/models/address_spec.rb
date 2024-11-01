# == Schema Information
#
# Table name: addresses
#
#  id         :integer(4)      not null, primary key
#  address1   :string(255)
#  address2   :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  country    :string(255)
#  model_id   :integer(4)
#  model_type :string(255)
#  created_at :datetime
#  updated_at :datetime
#  latitude   :float
#  longitude  :float
#

require 'spec_helper'

describe Address do
  should_belong_to :model, :polymorphic => true

  should_validate_presence_of :address1
  should_validate_presence_of :city
  should_validate_presence_of :zip
  should_validate_presence_of :state
  should_validate_presence_of :country
end
