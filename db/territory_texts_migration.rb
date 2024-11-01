def do_transaction
  ActiveRecord::Base.transaction do
    begin
      yield
    rescue => e
      puts e.inspect
      puts e.backtrace
      p Time.now
      raise ActiveRecord::Rollback
    end
  end
end


do_transaction do
  i = 0
  Territory.find_each do |t|
    #p t
    TerritoryText::CONTENTS_TYPES.each do |c|
      #p '--------------------- field'
      #p c
      #p '----------------------- original'
      #p t[c]
      t.send "#{c.to_s}=".to_sym, t[c]
      #p '------------------------ new'
      #p t.send c
      putc '.'
    end
    t.save
    #p '---------- discovery text'
    #p t.discovery_text
    #p t.rewards_text
    #p t.territory_texts

    #raise Exception.new if i == 0
    #break if i == 0
    i += i
  end
end

