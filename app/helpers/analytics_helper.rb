module AnalyticsHelper
  # TODO: I'm sure this can be cleaned up but works for migration scripts and new scripts
  def santize_google_analytics(lytics_code, default="UA-10145428-1")
    if lytics_code.include?("gaJsHost") || lytics_code.include?("script")
      stripped_code = lytics_code.scan(/_getTracker(.*?)\;/)
      stripped_code = lytics_code.scan(/_setAccount',(.*?)]/) if stripped_code.blank?
      
      unless stripped_code.blank?
        stripped_code = stripped_code.flatten[-1].strip.gsub("'","").gsub('"','').gsub("(","").gsub(")","")
      else
        return {:code => lytics_code, :success => false}
      end
    
      if default == stripped_code
        return {:code => nil, :success => false}
      else
        return {:code => stripped_code, :success => true}
      end
    
    else
      return {:code => lytics_code, :success => true}
    end
            
  rescue => e
    Rails.logger.error("ERROR: #{e} - Couldn't sanitize analytics code: #{lytics_code}")
    return {:code => lytics_code, :success => false}
  end
end