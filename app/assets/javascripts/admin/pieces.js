// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready(function(){
    fcms.bindTable($('.table'));
    fcms.initTable();
    fcms.bindForm($('form'), 3);

    // Remove default behavior and put logic for this specific page
    fcms.fnSuccessGetData = function( data ) {
        $('#piece_id').val(data['id']);
        $('#piece_title').val(data['title']);

        // Set school type
        $($('.select')[0]).val(data['composer']['id']);
        $($('.select')[1]).val(data['composer']['name']);
        $($('.select')[1]).attr('data-value', data['composer']['id']);
        $('#formModal').modal('show');
    };

    fcms.fnSuccessUpdateData = function( data ) {
        $('#formModal').modal('hide');
        var aItem = new Array();

        aItem.push(data['id']);
        aItem.push(data['title']);
        aItem.push(data['composer']['name']);
        aItem.push(fcms.fnFormatDate(data['created_at']));
        aItem.push(fcms.fnFormatDate(data['updated_at']));

        oTable.fnUpdate(aItem, fcms.fnGetSelected(oTable)[0]);

        fcms.fnClearForm();
        oTable.$('tr.row_selected').removeClass('row_selected');

        fcms.showMessage('L\'item a été modifié avec succès.');
    };

    fcms.fnSuccessAddItem = function( data ) {
        $('#formModal').modal('hide');
        var aItem = new Array();

        aItem.push(data['id']);
        aItem.push(data['title']);
        aItem.push(data['composer']['name']);
        aItem.push(fcms.fnFormatDate(data['created_at']));
        aItem.push(fcms.fnFormatDate(data['updated_at']));

        var iRow = oTable.fnAddData(aItem);

        $(oTable.fnGetNodes(iRow)).click( fcms.fnSelectableRows );

        fcms.fnClearForm();

        fcms.showMessage('L\'item a été ajouté avec succès.');

        oTable.$('tr.row_selected').removeClass('row_selected');
    };

    $('#piece_composer_id').typeahead();
});