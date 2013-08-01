// ckeditor
//= require ckeditor-jquery

var defaultOptions = {
  contentsCss: '/assets/ckeditor.css',
  linkShowAdvancedTab: true,
  scayt_autoStartup: true,
  enterMode: Number(2),
  removePlugins: 'elementspath'
};

fcms.ckeditor = function(control, options) {
  options = fcms.mergeObjects(defaultOptions, options);
  return $(control).ckeditor(options);
}