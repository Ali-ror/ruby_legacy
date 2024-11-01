# == Schema Information
#
# Table name: headers
#
#  id           :integer(4)      not null, primary key
#  territory_id :integer(4)
#  credit       :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  header       :string(255)
#  link         :string(255)
#

require 'spec_helper'

describe Header do
  should_belong_to :territory
end
