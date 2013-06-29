// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready( function () {
    fcms.bindTable($('.table'));
    fcms.initTable();
    fcms.bindForm($('form'), 3);
});

