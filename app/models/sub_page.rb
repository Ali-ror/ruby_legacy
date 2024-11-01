# == Schema Information
#
# Table name: sub_pages
#
#  id                       :integer(4)      not null, primary key
#  territory_id             :integer(4)
#  page_title               :string(255)
#  meta_content_description :string(255)
#  meta_tags                :string(255)
#  body_text                :text
#  created_at               :datetime
#  updated_at               :datetime
#


class SubPage < ActiveRecord::Base
  belongs_to :territory
  
  has_friendly_id :page_title, 
                  :use_slug => true, 
                  :approximate_ascii => true,
                  :reserved_words => ["new", "edit"]
  
  validates :page_title, :presence => true, :length => { :maximum => 30 }
  validates :body_text,  :presence => true
end
