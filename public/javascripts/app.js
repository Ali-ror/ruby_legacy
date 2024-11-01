$(function(){
  tabInit();
  
  // Clear Alerts
  $('.flash_message').delay(3000).fadeOut(2000);
  
  // Fancyboxify
  $(".fancy").fancybox({
    'titleShow' : true,
    'titlePosition' : 'inside'
  });

  $(".fancy_youtube").fancybox( {
    'type': 'swf',
    'padding': 0,
    'swf': { 
      'wmode': 'transparent', 
      'allowfullscreen': true }
  } );
  
  // Homepage trigger hidden tab if link clicked
  if (window.location.href.match("#connect")) { $("#action_three").click(); }
  $(".connect").click(function(){ $("#action_three").click(); });
});


// Tabbing support with any item or group
function tabInit(){
  $('.tab').each(function(){
    // Pull group and content block for tab
    group = $(this).attr("data-group");    
    use_highlight = $(this).attr("data-highlight");
    
    // Change cursor on hover
    $(this).hover(function(){ // Hover In
      document.body.style.cursor = 'pointer';
      
      if(use_highlight){
        $("[data-group='"  + group + "']").each(function(){
          target = $($(this).attr("data-ref"));
          if (target.css("display") == "none") { $(this).css("opacity","0.4") } ;
        });
        $(this).css("opacity","1.0");
      }
    }, function(){ // Hover Out
      document.body.style.cursor = 'default';
      
      if ( use_highlight ) {
        content_blocks = $("[data-group='"  + group + "']").map(function(){ 
          return $($(this).attr("data-ref")).css("display") 
        });
        selected_block_check = $.inArray("block", content_blocks);
        
        $("[data-group='"  + group + "']").each(function(){
          target = $($(this).attr("data-ref"));
          if (target.css("display") == "block" || selected_block_check == -1) { 
            $(this).css("opacity","1.0"); 
          } else {
            if ( selected_block_check != -1) { $(this).css("opacity","0.4"); }
          }
        });
      }
    });
    
    // Display proper content and allow the use of links as tabs
    $(this).click(function(){ 
      // Hide All Blocks                 
      $("[data-group='"  + group + "']").each(function(){
        target = $( $(this).attr( "data-ref" ) );
        //if ( target.css( "display" ) == "block" ) {
          target.hide();
        //}
      });

      // Display current block
      if(use_highlight){
        $("[data-group='"  + group + "']").each(function(){ 
          $(this).css("opacity","0.4"); 
        });
        $(this).css("opacity","1.0");
      }
      
      $($(this).attr("data-ref")).show();
      return false;
    });
    
    // Show Default Tab
    $('.tab').each(function(){
      if ($(this).attr("data-default") == "true") { 
        $(this).click(); 
      }
    });
    
  });
}
