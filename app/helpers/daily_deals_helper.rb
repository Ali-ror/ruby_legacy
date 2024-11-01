module DailyDealsHelper
  def generate_calendar
    calendar( :year => @date.year,
              :month => @date.month,
              :first_day_of_week => 0,
              :next_month_text => link_to( image_tag( "forward.png" ), :date => @date.next_month.strftime( "%Y-%m-%d" ) ),
              :previous_month_text => link_to( image_tag( "back.png" ), :date => @date.prev_month.strftime( "%Y-%m-%d" ) ) ) do |d|
      render_cell( d )
    end.html_safe
  end

  def render_cell( d )
    dd = @daily_deals.detect { |daily| daily.deal_date == d }

    links = content_tag :div, :class => "links" do
      if dd
        Rails.logger.debug can?( :update, dd ).inspect
        ( link_to( "Edit",   edit_admin_territory_daily_deal_path( @territory, dd ) ) if can?( :update, dd ) ) +
          content_tag( :br ) + 
          ( link_to( "Delete", admin_territory_daily_deal_path( @territory, dd ), :confirm => 'Are you sure you wish to delete this Deal of the Day?', :method => :delete ) if can?( :destroy, dd ) )
      else
        link_to "New", new_admin_territory_daily_deal_path( @territory, :date => d ) if can?( :create, DailyDeal )
      end
    end

    d.day.to_s + content_tag( :div, :class => "deal" ) do
      if dd
        ( content_tag( :div, dd.business_listing.name, :class => "listing_name" ) if dd ) +
          links
      else
        links
      end
    end
    # business_listing.name
    # edit/delete if business on this date
    # new if no bl on this date
  end

end