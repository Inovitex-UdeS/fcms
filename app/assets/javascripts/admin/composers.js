// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready(function(){

    var tsDTOptions = {
        "bInfo": false,
        "bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": $('#composers-table').data('source'),
        "fnDrawCallback": function( oSettings ) {
            // Add a click handler to the rows (selectable rows)
            $.each(oTable.fnGetNodes(), function() {
                $(this).single_double_click(fcms.fnSelectableRows, fcms.fnEditableRows);
            });
        }
    };

    fcms.bindTable($('#composers-table'));
    fcms.initTable(tsDTOptions);
    fcms.bindForm($('form'), 3);
});