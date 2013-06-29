// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready( function () {
    fcms.dataTables.bindTable($('.table'));
    fcms.dataTables.initTable();
    fcms.dataTables.bindForm($('form'), 3);
});

