ActiveRecord::Base.transaction do
  begin

    [ "Yelp", "MySpace", "YouTube Channel" ].each do |lt|
      LinkType.find_or_create_by_name( lt )
    end

    lt = LinkType.find_by_name "Blogger"
    lt.name = "Blog"
    lt.save( :validate => false )

    p LinkType.all.collect(&:name)

    #raise ActiveRecord::Rollback

  rescue => e
    puts e.inspect
    puts e.backtrace
    p Time.now
    raise ActiveRecord::Rollback
  end
end