

// General Application Functionality

$(function(){
  // Turn a group of links into remote links (originally for pagination)
  $("a.remote, .pagination.remote a").live("click", function(){
    $.getScript(this.href);
    return false;
  });

  // Common Search
  $("form.remote input").keyup(function(){
    var parentForm = $(this).parent().parent("form");
    if($(this).val().length > 1 || $(this).val() == "") {
      $.get(parentForm.action, parentForm.serialize(), null, "script");
    }
    return false;
  });

  $("input[type='checkbox'].remote, input[type='radio'].remote").change(function(){
    var parentForm = $(this).parent().parent("form");
    $.get(parentForm.action, parentForm.serialize(), null, "script");
    return false;
  });

  $('.wysiwyg').ckeditor( { toolbar: 'RLToolbar' } );
  $('.wysiwyg-light').ckeditor( { toolbar: 'RLMiniToolbar' } );

  // Fancyboxify
  $("a.image").fancybox({
   'transitionIn'  : 'elastic',
   'transitionOut' : 'fade',
   'speedOut'      : 100
  });

  $("a.image .content").css("display","none");

  $( 'form' ).attr( "novalidate", "" );

  $('form a.add_link').live('click', function() {
    var assoc   = $(this).attr('data-association');           // Name of child
    var content = $('#' + assoc + '_fields_blueprint').html(); // Fields template
    var count   = $('#' + assoc + '_fields_blueprint').attr( "data-count" );

    $(this).before(content);

    if ( $(this).closest( ".fieldset" ).find( ".fields:visible" ).size() >= parseInt( count ) ) {
      $( this ).hide();
    }

    return false;
  });

  $('form a.remove_link').live('click', function() {
    var assoc = $(this).attr('data-association');
    var count = $('#' + assoc + '_fields_blueprint').attr( "data-count" );

    if ( $(this).parents( ".fieldset" ).find( ".fields:visible" ).size() <= parseInt( count ) ) { // >= cause we are removing this one
      $( this ).parents( ".fieldset" ).find( "a.add_link" ).show();
    }

    $(this).closest('.fields').remove();
    return false;
  });

  forceTinyMceIframeResize();

});

function forceTinyMceIframeResize() {
  $('.mceEditor .mceIframeContainer iframe').each(function (i) {
    $(this).height($(this).height() + 1);
  });
}
