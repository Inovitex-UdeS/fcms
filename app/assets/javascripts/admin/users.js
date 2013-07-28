// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

$(document).ready(function(){

    var tsDTOptions = {
        "bInfo": false,
        "bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": $('#users-table').data('source'),
        "fnDrawCallback": function( oSettings ) {
            // Add a click handler to the rows (selectable rows)
            $.each(oTable.fnGetNodes(), function() {
                $(this).single_double_click(fcms.fnSelectableRows, fcms.fnEditableRows);
            });
        }
    };

    fcms.bindTable($('#users-table'));
    fcms.initTable(tsDTOptions);
    fcms.bindForm($('form'), 2);

    // Remove default behavior and put logic for this specific page
    fcms.fnSuccessGetData = function( data ) {

        $('#user_id').val(data['id']);
        $('#user_first_name').val(data['first_name']);
        $('#user_last_name').val(data['last_name']);

        // Set gender
        $('#user_gender').val(data['gender'] ? 'Masculin' : 'Féminin');

        $('#user_birthday').val(data['birthday']);
        $('#user_contactinfo_attributes_telephone').val(data['contactinfo']['telephone']);
        $('#user_contactinfo_attributes_address').val(data['contactinfo']['address']);
        $('#user_contactinfo_attributes_address2').val(data['contactinfo']['address2']);
        $('#user_contactinfo_attributes_postal_code').val(data['contactinfo']['postal_code']);

        // Set city
        $('#user_contactinfo_attributes_city_id').val(data['contactinfo']['city']['id']);

        $('#user_contactinfo_attributes_province').val(data['contactinfo']['province']);
        $('#formModal').modal('show');
    };

    fcms.fnSuccessUpdateData = function( data ) {
        $('#formModal').modal('hide');

        var aItem = new Array();

        aItem.push(data['id']);
        aItem.push(data['last_name']);
        aItem.push(data['first_name']);
        aItem.push(data['email']);
        aItem.push(data['confirmed_at'] ? "oui" : "non");
        aItem.push(fcms.fnFormatDate(data['created_at']));
        aItem.push(fcms.fnFormatDate(data['updated_at']));

        oTable.fnUpdate(aItem, fcms.fnGetSelected(oTable)[0]);

        fcms.fnClearForm();
        oTable.$('tr.row_selected').removeClass('row_selected');

        fcms.showMessage('L\'item a été modifié avec succès.');
    };
});