class LegacySetupPage < LegacyBase
  set_table_name 'setup_page'
  set_primary_key 'page_id'

  scope :contact_us, where( :page_name => "Contact Us" )

  def self.contact_us_content
    CGI.unescapeHTML( self.contact_us.first.page_content )
  end
end
