// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Datatables and plugins
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap

var oTable;

$(document).ready(function() {

    // DataTables
    oTable = $('#edit_user_table').dataTable({
        "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
        "sPaginationType": "bootstrap" ,
        "oLanguage": {
            "sProcessing":     "Traitement en cours...",
            "sSearch":         "Rechercher&nbsp;:",
            "sLengthMenu":     "Afficher _MENU_ &eacute;l&eacute;ments",
            "sInfo":           "Affichage de l'&eacute;lement _START_ &agrave; _END_ sur _TOTAL_ &eacute;l&eacute;ments",
            "sInfoEmpty":      "Affichage de l'&eacute;lement 0 &agrave; 0 sur 0 &eacute;l&eacute;ments",
            "sInfoFiltered":   "(filtr&eacute; de _MAX_ &eacute;l&eacute;ments au total)",
            "sInfoPostFix":    "",
            "sLoadingRecords": "Chargement en cours...",
            "sZeroRecords":    "Aucun &eacute;l&eacute;ment &agrave; afficher",
            "sEmptyTable":     "Aucune donnée disponible dans le tableau",
            "oPaginate": {
                "sFirst":      "Premier",
                "sPrevious":   "Pr&eacute;c&eacute;dent",
                "sNext":       "Suivant",
                "sLast":       "Dernier"
            },
            "oAria": {
                "sSortAscending":  ": activer pour trier la colonne par ordre croissant",
                "sSortDescending": ": activer pour trier la colonne par ordre décroissant"
            }
        }
    });

    if ( oTable ) {
        $.each(oTable.fnGetNodes(), function() {
            $(this).click( fnSelectableRows );
        });

        fnClearForm();

        // Add ajax callbacks
        $('form input[type=submit]').click(function(){
            // Update item
            if($('#user_id').val()) {
                $.ajax({
                    url     : '/users/' + $('#user_id').val(),
                    type    : 'put',
                    dataType: 'json',
                    data    : $('form').serialize(),
                    success : function( data ) {
                        var aItem = new Array();

                        aItem.push(data['id']);
                        aItem.push(data['first_name']);
                        aItem.push(data['last_name']);
                        aItem.push(data['email']);

                        oTable.fnUpdate(aItem, fnGetSelected(oTable)[0]);

                        fnClearForm();
                        oTable.$('tr.row_selected').removeClass('row_selected');

                        fcms.showMessage('L\'item a été modifié avec succès.');
                    },
                    error   : function( xhr, err ) {
                        fcms.showMessage('L\'item n\'a pas été modifé');
                    }
                });
            }
            return false;
        });

    }

});

// Selectable rows
function fnSelectableRows ( e ) {
    if ($(this).hasClass('row_selected')) {
        $(this).removeClass('row_selected');
        fnClearForm();
    }
    else {
        oTable.$('tr.row_selected').removeClass('row_selected');
        $(this).addClass('row_selected');
        var id = $(this).children().first().text();

        $.ajax({
            url     : '/users/' + '/' + id,
            type    : 'GET',
            dataType: 'json',
            success : function( data ) {
                $('#user_id').val(data['id']);
                $('#user_first_name').val(data['first_name']);
                $('#user_last_name').val(data['last_name']);
                $('#user_birthday').val(data['birthday']);
                $('#user_contactinfo_attributes_telephone').val(data['contactinfo']['telephone']);
                $('#user_contactinfo_attributes_address').val(data['contactinfo']['address']);
                $('#user_contactinfo_attributes_address2').val(data['contactinfo']['address2']);
                $('#user_contactinfo_attributes_postal_code').val(data['contactinfo']['postal_code']);
                $('#input-cities').val(data['contactinfo']['city']['name']);
                $('#user_contactinfo_attributes_city_attributes_id').val(data['contactinfo']['city_id']);
                $('#user_contactinfo_attributes_province').val(data['contactinfo']['province']);
                $('#user_contactinfo_attributes_id').val(data['contactinfo_id']);
            }
        });
    }
};

// Get the rows which are currently selected
function fnGetSelected ( oTableLocal ) {
    return oTableLocal.$('tr.row_selected');
};

// Clear form
function fnClearForm() {
    $('form input').filter(function() { return this.name.match(/^user.*/g); }).each(
        function(){
            $(this).val('');
        }
    );
}