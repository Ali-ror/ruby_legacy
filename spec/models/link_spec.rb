# == Schema Information
#
# Table name: links
#
#  id           :integer(4)      not null, primary key
#  url          :string(255)
#  link_type_id :integer(4)
#  model_id     :integer(4)
#  model_type   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Link do
  should_belong_to :link_type 

  should_belong_to :model, :polymorphic => true 
end
