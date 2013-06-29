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

    fcms.bindTable($('.table'));
    fcms.initTable();
    fcms.bindForm($('form'), 3);
});