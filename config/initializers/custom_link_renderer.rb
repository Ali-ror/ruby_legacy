module WillPaginate
  module ViewHelpers
    class CustomLinkRenderer < LinkRenderer
      def to_html
        html = pagination.map do |item|
          item.is_a?(Fixnum) ?
            page_number(item) :
            send(item)
        end.join(@options[:separator])
        
        tag(:ol, html, :class => "navcnt")
      end
    
      protected
      
      def page_number(page)
        unless page == current_page
          tag(:li, link(page, page, :rel => rel_value(page)))
        else
          tag(:li, link(page, "#", :rel => rel_value(page)), :class => "current")
        end
      end
      
      def previous_or_next_page(page, text, classname)
        if page
          tag(:li, link(text, page, :class => classname))
        end
      end
        
    end
  end
end