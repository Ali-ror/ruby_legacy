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

require 'spec_helper'

describe Affiliate do
  should_belong_to :territory
end
