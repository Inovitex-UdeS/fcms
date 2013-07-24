// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready(function(){
    fcms.bindTable($('.table'));
    fcms.initTable();
    fcms.bindForm($('form'), 3);

    // Remove default behavior and put logic for this specific page
    fcms.fnSuccessAddItem = function( data ) {
        $('#formModal').modal('hide');
        var aItem = new Array();

        aItem.push(data['id'])
        aItem.push(data['name'])
        aItem.push(data['schoolboard']['name'])
        aItem.push(data['schooltype']['name'])
        aItem.push(fcms.fnFormatDate(data['created_at']));
        aItem.push(fcms.fnFormatDate(data['updated_at']));

        var iRow = oTable.fnAddData(aItem);

        $(oTable.fnGetNodes(iRow)).click( fcms.fnSelectableRows );

        fcms.fnClearForm();

        fcms.showMessage('L\'institution scolaire a été ajoutée avec succès.');

        oTable.$('tr.row_selected').removeClass('row_selected');
    };

    // Remove default behavior and put logic for this specific page
    fcms.fnSuccessUpdateData = function( data ) {
        $('#formModal').modal('hide');
        var aItem = new Array();

        aItem.push(data['id'])
        aItem.push(data['name'])
        aItem.push(data['schoolboard']['name'])
        aItem.push(data['schooltype']['name'])
        aItem.push(fcms.fnFormatDate(data['created_at']));
        aItem.push(fcms.fnFormatDate(data['updated_at']));

        oTable.fnUpdate(aItem, fcms.fnGetSelected(oTable)[0]);

        fcms.fnClearForm();
        oTable.$('tr.row_selected').removeClass('row_selected');

        fcms.showMessage('L\'institution soclaire a été modifiée avec succès.');
    };

    // Remove default behavior and put logic for this specific page
    fcms.fnSuccessGetData = function( data ) {

        $('#school_id').val(data['id']);
        $('#school_name').val(data['name']);

        // Set school type
        $($('.select')[0]).val(data['schooltype']['id']);
        $($('.select')[1]).val(data['schooltype']['name']);
        $($('.select')[1]).attr('data-value', data['schooltype']['id']);

        // Set schoolboard
        $($('.select')[2]).val(data['schoolboard']['id']);
        $($('.select')[3]).val(data['schoolboard']['name']);
        $($('.select')[3]).attr('data-value', data['schoolboard']['id']);

        $('#school_contactinfo_attributes_telephone').val(data['contactinfo']['telephone']);
        $('#school_contactinfo_attributes_address').val(data['contactinfo']['address']);
        $('#school_contactinfo_attributes_address2').val(data['contactinfo']['address2']);
        $('#school_contactinfo_attributes_postal_code').val(data['contactinfo']['postal_code']);

        // Set city
        $($('.select')[4]).val(data['contactinfo']['city']['id'])
        $($('.select')[5]).val(data['contactinfo']['city']['name']);
        $($('.select')[5]).attr('data-value', data['contactinfo']['city']['id']);
        $('#school_contactinfo_attributes_province').val(data['contactinfo']['province']);

        $('#formModal').modal('show');
    };

    $('#school_schooltype_id').typeahead();
    $('#school_schoolboard_id').typeahead();
    $('#school_contactinfo_attributes_city_id').typeahead();



});