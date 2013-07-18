// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready(function() {
    $('#edition_limit_date').datepicker({
        format: 'yyyy-mm-dd',
        viewMode: 2
    });

    $('#edition_start_date').datepicker({
        format: 'yyyy-mm-dd',
        viewMode: 2
    });

    $('#edition_end_date').datepicker({
        format: 'yyyy-mm-dd',
        viewMode: 2
    });

    $('#edition_edit_limit_date').datepicker({
        format: 'yyyy-mm-dd',
        viewMode: 2
    });

    fcms.bindTable($('.table'));
    fcms.initTable();
    fcms.bindForm($('#new_edition'), 3);

    $('#edit_edition_2').on('ajax:success', function(evt, data, status, xhr) {
        fcms.showMessage('La mise à jour de l\'édition courante a été complétée avec succès!');
    });

    $('#edit_edition_2').on('ajax:error', function(event, xhr, status) {
        fcms.showMessage(xhr.responseText, 3);
    });
});