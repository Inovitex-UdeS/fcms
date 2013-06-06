// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

//  jQuery and plugins
//= require jquery
//= require jquery_ujs

//  HTML forms
//= require nested_form
//= require jquery.remotipart
//= require rails.validations
//= require rails.validations.simple_form

//  Bootstrap and underscore
//= require twitter/bootstrap
//= require jasny-bootstrap
//= require bootstrap-datepicker
//= require underscore

/*  --- SCRIPT --- */

// Create fcms object for global functions and variables
var fcms = fcms || {};

// Shows a notification message in the main window
fcms.showMessage = function(message, type) {
    // Create message division
    var curmsg = $('<div></div>').addClass('fcms-message alert')
                                 .html(message).appendTo('body');

    // Add 'alert' or 'error' class
    if      (_.contains(['i', 'info',  'information', 1], type))  curmsg.addClass('alert-info')
    else if (_.contains(['a', 'alert', 'warning',     2], type))  curmsg.addClass('')
    else if (_.contains(['e', 'error', 'danger',      3], type))  curmsg.addClass('alert-error')
    else                                                          curmsg.addClass('alert-success');

    // Update size and position, then hide and fade in
    curmsg.css({ 'marginLeft': -curmsg.width() / 2, 'left': '50%' })
          .prepend('<button type="button" class="close" data-dismiss="alert">&times;</button>')
          .hide().fadeIn('fast');

    // Clear after 2.5s
    window.setTimeout(function() {
        curmsg.fadeOut('fast', function(){ curmsg.remove(); });
    }, 2500);
}
