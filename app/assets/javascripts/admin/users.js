// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready(function(){
    fcms.bindTable($('.table'));
    fcms.initTable();
    fcms.bindForm($('form'), 2);

    // Remove default behavior and put logic for this specific page
    fcms.fnSuccessGetData = function( data ) {

        $('#user_id').val(data['id']);
        $('#user_first_name').val(data['first_name']);
        $('#user_last_name').val(data['last_name']);

        // Set gender
        $($('.select')[0]).val(data['gender']);
        $($('.select')[1]).val(data['gender'] ? 'Masculin' : 'Féminin');
        $($('.select')[1]).attr('data-value', data['gender']);

        $('#user_birthday').val(data['birthday']);
        $('#user_contactinfo_attributes_telephone').val(data['contactinfo']['telephone']);
        $('#user_contactinfo_attributes_address').val(data['contactinfo']['address']);
        $('#user_contactinfo_attributes_address2').val(data['contactinfo']['address2']);
        $('#user_contactinfo_attributes_postal_code').val(data['contactinfo']['postal_code']);

        // Set city
        $($('.select')[2]).val(data['contactinfo']['city']['id'])
        $($('.select')[3]).val(data['contactinfo']['city']['name']);
        $($('.select')[3]).attr('data-value', data['contactinfo']['city']['id']);
        $('#user_contactinfo_attributes_province').val(data['contactinfo']['province']);
    };

    $('#user_gender').typeahead();
    $('#user_contactinfo_attributes_city_id').typeahead();
});