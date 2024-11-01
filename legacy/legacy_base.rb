class LegacyBase < ActiveRecord::Base
  establish_connection :adapter  => 'mysql2',
    :host     => 'localhost',
    :username => 'root',
    :password => 'hnWLt71',
    :database => ENV['legacy_db'],
    :encoding => 'utf8'

  #puts "setting connection"
  #connection.execute "SET collation_connection = 'utf8_general_ci'"
  
  def filename
    "#{self.listing_id}_#{self.id}.#{self.extension}"
  end

  def status_to_state( column )
    case eval( "self.#{column}" )
      when "approved"
        BusinessListing::APPROVED
      when "rejected"
        BusinessListing::REJECTED
      when "pending"
        BusinessListing::PENDING
    end
  end

end
