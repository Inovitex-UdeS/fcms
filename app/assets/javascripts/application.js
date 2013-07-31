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
//= require select2
//= require select2_locale_fr
//= require underscore
//= require bootstrap-bigmodal

// for pie charts
//= require d3
//= require ckeditor-jquery

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
};

// Format date to Rails format
fcms.fnFormatDate = function ( unformattedDate ) {
    var date = new Date(unformattedDate);
    var cur_month = date.getMonth()+1;
    if (cur_month < 10) cur_month =  "0" + cur_month;

    var cur_date = date.getUTCDate();
    if (cur_date < 10) cur_date =  "0" + cur_date;

    var cur_hour = date.getUTCHours();
    if (cur_hour < 10) cur_hour =  "0" + cur_hour;

    var cur_min = date.getUTCMinutes();
    if (cur_min < 10) cur_min =  "0" + cur_min;

    var cur_sec = date.getUTCSeconds();
    if (cur_sec < 10) cur_sec =  "0" + cur_sec;

    return cur_date + '/' + cur_month + '/' + date.getFullYear();
};

// Elegant solution for single double-click
jQuery.fn.single_double_click = function(single_click_callback, double_click_callback, timeout) {
    return this.each(function(){
        var clicks = 0, self = this;
        jQuery(this).click(function(event){
            clicks++;
            if (clicks == 1) {
                single_click_callback.call(self, event);
                setTimeout(function(){
                    if(clicks == 1) {
                        //single_click_callback.call(self, event);
                    } else {
                        double_click_callback.call(self, event);
                    }
                    clicks = 0;
                }, timeout || 300);
            }
        });
    });
}

// Serialize an HTML form to JavaScript object using jQuery.serializeArray
jQuery.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] && !$('input[name="' + this.name + '"][type="checkbox"]').length) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });

    return o;
};

// Merge 2 objects together
fcms.mergeObjects = function(obj1, obj2) {
    if (obj2)
        for (var i in obj2) {
            if (obj1[i] != null && typeof obj1[i] === 'object')
                fcms.mergeObjects(obj1[i], obj2[i]);
            else obj1[i] = obj2[i];
        }
    return obj1;
}

// Remove the '#' action from links
$(document).ready(function() {
    $('a[href="#"]').click(function(e) {
        e.preventDefault();
    });
});