// Easily add autocomplete with consistent formatting to any page
(function($){  
  $.fn.extend({
    initAutoComplete:function(options) {
      return this.each(function(){        
        var opts = options;

        $(this).autocomplete({
          minLength: 2,
          source: function(request, response){
            $.ajax({
              url: opts.url,
              data: { keyword: request.term },
              success: function(data){
                response(parseResult(data));
              }
            });
          },
          select: function(event,ui) {
            $(opts.target_field).val( eval("ui.item." + opts.target_field_value));
          }
        });
 
      });
      
      // Result Formatting
      // TODO: Support multiple formats?
      function parseResult(data){
        var formatting = $.map(data, function(item) {
          return {
            label: item.first_name + " " + item.last_name + " (" + item.email + ")",
            value: item.name,
            id: item.id
          }
        });
        return formatting;
      }      
    }
  });
  
})(jQuery);