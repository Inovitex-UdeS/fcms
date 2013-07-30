// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready(function(){

    var tsDTOptions = {
        "bInfo": false,
        "bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": $('#pieces-table').data('source'),
        "fnDrawCallback": function( oSettings ) {
            // Add a click handler to the rows (selectable rows)
            $.each(oTable.fnGetNodes(), function() {
                $(this).single_double_click(fcms.fnSelectableRows, fcms.fnEditableRows);
            });
        }
    };

    fcms.bindTable($('#pieces-table'));
    fcms.initTable(tsDTOptions);
    fcms.bindForm($('form'), 4);


    // Remove default behavior and put logic for this specific page
    fcms.fnSuccessGetData = function( data ) {
        $('#piece_id').val(data['id']);
        $('#piece_title').val(data['title']);
        $('#piece_composer_id').select2('data', {value: data['composer']['id'], label: data['composer']['name']});

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

    $('#piece_composer_id').select2({
        minimumInputLength: 2,
        id: function(e) {
            return e.value;
        },
        ajax: {
            url: '/autocomplete/composers',
            dataType: 'json',
            type: "GET",
            data: function (term, page) {
                return {
                    composer: term
                };
            },
            results: function (data, page) {
                return {
                    results: data
                };
            }
        },
        formatResult: function (item) {
            return ('<div>' + item.label + '</div>');
        },
        formatSelection: function (item) {
            return (item.label);
        },
        escapeMarkup: function (m) {
            return m;
        }
    });

    // Clear the form
    fcms.fnClearForm = function () {
        $('#piece_composer_id').select2('data', null);
        $('form')[0].reset();
    };
});