// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready(function() {
    $('#role_user_ids').typeahead();
    fcms.bindTable($('.table'));
    fcms.initTable();
    fcms.fnInjectDeleteButton('/admin/juges/', $('#role_user_ids'));

    $('form').on('ajax:success', function(evt, data, status, xhr) {
        fcms.showMessage('L\'item a été ajouté avec succès!');

        var aItem = new Array();
        aItem.push(data['id']);
        aItem.push(data['first_name'] + ' ' + data['last_name']);
        aItem.push(data['email']);
        aItem.push(fcms.fnFormatDate(data['created_at']));

        var iRow = oTable.fnAddData(aItem);
        $(oTable.fnGetNodes(iRow)).click( fcms.fnSelectableRows );

        delete $('#role_user_ids').data('typeahead').source[data['id']];

        $('form')[0].reset();
    });

    $('form').on('ajax:error', function(event, xhr, status) {
        fcms.showMessage(xhr.responseText, 3);
    });
});