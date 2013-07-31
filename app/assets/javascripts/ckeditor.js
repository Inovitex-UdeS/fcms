// ckeditor
//= require ckeditor-jquery

var defaultOptions = {
  contentsCss: '/assets/ckeditor.css',
  linkShowAdvancedTab: false,
  scayt_autoStartup: true,
  enterMode: Number(2),
  toolbar: [
    [ 'Bold', 'Italic', 'Underline', 'Strike Through', '-', 'Subscript', 'Superscript' ],
    [ 'NumberedList', 'BulletedList' ],
    [ 'Link', 'Unlink' ]
  ]
};

fcms.ckeditor = function(control, options) {
  options = fcms.mergeObjects(defaultOptions, options);
  return $(control).ckeditor(options);
}