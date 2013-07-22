// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
    $('#user_birthday').datepicker({
        format: 'yyyy-mm-dd',
        viewMode: 2
    });

    $('#user_contactinfo_attributes_city_id').typeahead();
    $('#user_school_id').typeahead();
});