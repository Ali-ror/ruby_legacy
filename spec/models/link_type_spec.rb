# == Schema Information
#
# Table name: link_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe LinkType do
  should_have_many :links
end
