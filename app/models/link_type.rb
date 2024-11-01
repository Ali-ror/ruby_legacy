# == Schema Information
#
# Table name: link_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class LinkType < ActiveRecord::Base
  has_many :links

  default_scope order( :name )

  def label
    type
  end
end
