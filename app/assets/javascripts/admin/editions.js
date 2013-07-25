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

    fcms.fnSuccessAddItem = function( data ) {
        $('#formModal').modal('hide');

        var aItem = new Array();

        $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
            function(){
                var field = $(this).attr('id').replace(/^[a-zA-Z0-9]+_/g, '');
                if (field in data) {
                    aItem.push(data[field]);
                }

            }
        );

        aItem.push(fcms.fnFormatDate(data['created_at']));
        aItem.push(fcms.fnFormatDate(data['updated_at']));

        var iRow = oTable.fnAddData(aItem);

        $(oTable.fnGetNodes(iRow)).single_double_click(fcms.fnSelectableRows, fcms.fnEditableRows);

        fcms.fnClearForm();

        $('#edition_id').append($('<option>', {
            value: aItem[0],
            text : aItem[1]
        }));

        fcms.showMessage('L\'item a été ajouté avec succès.');

        oTable.$('tr.row_selected').removeClass('row_selected');
    };


    fcms.fnSuccessUpdateData = function( data ) {
        $('#formModal').modal('hide');

        var aItem = new Array();

        $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
            function(){
                var field = $(this).attr('id').replace(/^[a-zA-Z0-9]+_/g, '');
                if (field in data) {
                    aItem.push(data[field]);
                }
            }
        );
        aItem.push(fcms.fnFormatDate(data['created_at']));
        aItem.push(fcms.fnFormatDate(data['updated_at']));

        var selected = fcms.fnGetSelected(oTable)[0];
        var value = $(selected).children().first().text();

        oTable.fnUpdate(aItem, selected);

        $("#edition_id option[value=\'"+ value +"\']").text(aItem[1]);

        fcms.fnClearForm();
        oTable.$('tr.row_selected').removeClass('row_selected');

        fcms.showMessage('L\'item a été modifié avec succès.');
    };

    fcms.fnSuccessRemoveData = function(result) {
        var selected = fcms.fnGetSelected( oTable );
        fcms.showMessage('L\'item a été supprimé avec succès');
        oTable.fnDeleteRow(selected[0]);
        $("#edition_id option[value=\'"+ $(selected).children().first().text() +"\']").remove();
        fcms.fnClearForm();
    };


    fcms.bindTable($('.table'));
    fcms.initTable();
    fcms.bindForm($('#new_edition'), 3);

    $('form[action="/admin/currenteditions"]').on('ajax:success', function(evt, data, status, xhr) {
        fcms.showMessage('La mise à jour de l\'édition courante a été complétée avec succès!');
    });

    $('form[action="/admin/currenteditions"]').on('ajax:error', function(event, xhr, status) {
        fcms.showMessage(xhr.responseText, 3);
    });
});