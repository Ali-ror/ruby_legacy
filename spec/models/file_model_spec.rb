# == Schema Information
#
# Table name: file_models
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  business_listing_id :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  file_attachment     :string(255)
#

require 'spec_helper'

describe FileModel do
  should_belong_to :business_listing
end
