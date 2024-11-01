# == Schema Information
#
# Table name: banners
#
#  id           :integer(4)      not null, primary key
#  territory_id :integer(4)
#  active       :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#  link         :string(255)
#  size         :string(255)
#  banner       :string(255)
#

require 'spec_helper'

describe Banner do
  should_belong_to :territory
  
  it "has a properly defined factory" do
    b = Factory.create :banner
  end

end
