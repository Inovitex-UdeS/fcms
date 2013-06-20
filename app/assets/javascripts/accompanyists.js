//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap

$(document).ready(function() {
    var oForm = $('form');

    // Copy the form url for further usage
    modelUrl = $(oForm).attr('action');
    if(!/\/$/.test(modelUrl))
        modelUrl += '/';

    // Find the modelName out of the id
    modelName = $(oForm).attr('id').replace(/^[a-zA-Z0-9]+_/g, '');

    // Create regular expression to find inputs
    re = new RegExp(modelName + '.*', 'g');
    $('#user_birthday').datepicker({
        format: 'yyyy-mm-dd',
        viewMode: 2
    });

    var labels, mapped
    $("#input-cities").typeahead({
        source: function (query, process) {
            $.get('/autocomplete/cities', { q: query }, function (data) {
                labels = []
                mapped = {}

                $.each(data, function (i, item) {
                    mapped[item.label] = item.value
                    labels.push(item.label)
                })

                process(labels)
            })
        }
    });

    // Accompanyists Grid
    var oTableAccompanyists = $('#tableAccompanyists').dataTable({
        "bInfo": false,
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

    // Add delete button
    $('#tableAccompanyists_wrapper .row-fluid:last .span6:first').html('<a id="deleteItem" class="btn btn-primary" href="#">Supprimer</a></div>');

    // Add delete button's click handler
    $('#deleteItem').click( function() {
        var anSelected = fcms.fnGetSelected( oTableAccompanyists );
        if ( anSelected.length !== 0 ) {
            var id = oTableAccompanyists.fnGetData(oTableAccompanyists.fnGetPosition(anSelected[0]))[0];
            $.ajax({
                url: modelUrl + id,
                type: 'DELETE',
                complete: function(result) {
                    var aItem = Array();

                    oTableAccompanyists.fnDeleteRow(anSelected[0]);
                    fcms.showMessage('L\'item a été effacé avec succès.');
                }
            });
        }
    } );

    var oTableUsers = $('#tableUsers').dataTable({
        "bInfo": false,
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

    $("#tableUsers tbody tr").click(function(event) {
        fcms.fnSelectableRows($(this));
    });

    $("#tableAccompanyists tbody tr").click(function(event) {
        fcms.fnSelectableRows($(this));
    });

    // Add ajax callbacks
    $("input[type=submit]",oForm).click(function(){
        var formId;

        $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(/.*_id/g); }).each(
            function(){
                formId = $(this);
            }
        );

        var userAgreement = $('#userAgreement').is(':checked');

        // Update item
        if (formId.val() && userAgreement) {
            var params = [];
            params['id'] = formId.val();
            params['userAgreement'] = userAgreement;

            var paramsJSON = JSON.stringify(params);
            console.log(paramsJSON);
            $.ajax({
                url     : modelUrl + formId.val(),
                type    : 'put',
                dataType: 'json',
                data    : oForm.serialize(),
                success : function( data ) {
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

                    var iRow = oTableAccompanyists.fnAddData(aItem);

                    fcms.fnClearForm();
                    var row = fcms.fnGetSelected(oTableUsers);
                    oTableUsers.fnDeleteRow(row);

                    fcms.showMessage('L\'item a été modifié avec succès.');
                },
                error   : function( xhr, err ) {
                    fcms.showMessage('L\'item n\'a pas été ajouté');
                }
            });
        }

        // Form has no id, an error occurred.
        else {
            fcms.showMessage('Sélectionner d\'abord un utilisateur.');
        }

        return false;
    });

    fcms.fnSelectableRows = function ( row ) {
        // If item is already selected
        if (row.hasClass('row_selected')) {
            row.removeClass('row_selected');
            fcms.fnClearForm();
        }

        // If item isn't already selected
        else {
            oTableUsers.$('tr.row_selected').removeClass('row_selected');
            row.addClass('row_selected');
            var id = row.children().first().text();

            $.ajax({
                url     : modelUrl + id,
                type    : 'GET',
                dataType: 'json',
                success : function( data ) {
                    $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
                        function(){
                            var field = $(this).attr('id').replace(modelName + "_", "");
                            if (field in data) {
                                $(this).val(data[field]);
                            }
                        }
                    );
                }
            });
        }
    };

    fcms.fnClearForm = function ( e ) {
        $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
            function(){
                $(this).val('');
            }
        );
    };

    fcms.fnGetSelected = function ( oTable ) {
        return oTable.$('tr.row_selected');
    };
});