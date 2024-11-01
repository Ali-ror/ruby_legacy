/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';



    config.toolbar_RLToolbar =
      [
        { name:'clipboard', items:[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
        { name:'editing', items:[ 'Find', 'Replace', '-', 'SelectAll', '-', 'Scayt', '-', 'Preview' ] },
        { name:'insert', items:[ 'Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar' ] },
        '/',
        { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv',
        	'-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
        { name:'tools', items:[ 'Maximize', '-', 'About', '-', 'Source' ] },
        { name:'links', items:[ 'Link', 'Unlink', 'Anchor' ] },
        '/',
        { name: 'styles', items : [ 'Styles','Format','FontSize', 'TextColor', 'BGColor' ] },
        { name:'basicstyles', items:[ 'Bold', 'Italic', 'Strike', '-', 'RemoveFormat' ] }
      ];

    config.toolbar_RLMiniToolbar =
      [
        { name:'basicstyles', items:[ 'Bold', 'Italic', 'Underline' ] }
      ];
};
