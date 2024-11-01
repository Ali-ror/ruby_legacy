# == Schema Information
#
# Table name: territory_texts
#
#  id            :integer(4)      not null, primary key
#  territory_id  :integer(4)
#  contents_type :string(50)
#  contents      :text(2147483647
#  created_at    :datetime
#  updated_at    :datetime
#

class TerritoryText < ActiveRecord::Base
  belongs_to :territory

  CONTENTS_TYPES = [ :can_rely_text, :discovery_text, :save_text, :connect_text,
                     :what_is_relylocal, :advertise_with_us, :list_your_businesses,
                     :show_your_support, :contact_us, :rewards_text, :mobile_contact_us,
                     :local_jobs_text ]

end
