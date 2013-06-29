// Datatables and plugins
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap

var oTable;
var oForm;
var modelName;
var modelUrl;
var re;

fcms.dataTables.bindTable = function (table) {
    if (table) {
        // Copy the table
        oTable = $(table);
    }
    else {
        // Find default table
        oTable = $('.table');
    }
};

// By default bindForm() will put selectable rows
// Type value:
//   - 0 For nothing (selectable rows only for modification in the form)
//   - 1 For add button only
//   - 2 For remove button only
//   - 3 For add & remove buttons
// ALWAYS CALL BINDFORM AFTER INITTABLE
fcms.dataTables.bindForm = function (form, type) {

    // Copy the form
    oForm = $(form);

    // Copy the form url for further usage
    modelUrl = oForm.attr('action');
    if(!/\/$/.test(modelUrl))
        modelUrl += '/';

    // Find the modelName out of the id
    modelName = oForm.attr('id').replace(/^[a-zA-Z0-9]+_/g, '');

    // Create regular expression to find inputs
    re = new RegExp(modelName + '.*', 'g');

    // Add a click handler to the rows (selectable rows)
    $.each(oTable.fnGetNodes(), function() {
        $(this).click( fcms.dataTables.fnSelectableRows );
    });

    var htmlToInput = '';

    switch(type)
    {
        case 1:
            htmlToInput = '<a id="addItem" class="btn btn-primary" href="#">Ajouter</a>';
            break;
        case 2:
            htmlToInput = '<a id="deleteItem" class="btn" href="#">Supprimer</a></div>';
            break;
        case 3:
            htmlToInput = '<a id="addItem" class="btn btn-primary" href="#">Ajouter</a><a id="deleteItem" class="btn" href="#">Supprimer</a></div>';
            break;
    }

    // Add a + and/or - button
    $('.row-fluid:last > .span6:first').html(htmlToInput);

    // Add button section
    if(type == 1 || type == 3){
        // Prevent scrolling top when clicking on button
        $('#addItem').click(function(e){ e.preventDefault(); $.get(modelUrl) });

        // Add click handler (will clear the form)
        $('#addItem').click( function() {
            oTable.$('tr.row_selected').removeClass('row_selected');
            fcms.dataTables.fnClearForm();
        });
    }

    // Delete button section
    if(type == 2 || type == 3){
        // Prevent scrolling top
        $('#deleteItem').click(function(e){ e.preventDefault(); $.get(modelUrl) });

        // Add a click handler for the delete button
        $('#deleteItem').click( function() {
            var anSelected = fcms.dataTables.fnGetSelected( oTable );
            if ( anSelected.length !== 0 ) {
                var id = oTable.fnGetData(oTable.fnGetPosition(anSelected[0]))[0];
                $.ajax({
                    url: modelUrl + id,
                    type: 'DELETE',
                    complete: function(result) {
                        oTable.fnDeleteRow(anSelected[0]);
                        fcms.dataTables.fnClearForm();
                    }
                });
            }
        });
    }

    // Add ajax callbacks
    $("input[type=submit]", oForm).click(function(){
        var formId;

        $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(/.*_id/g); }).each(
            function(){
                formId = $(this);
            }
        );

        // Update item
        if(formId.val()) {
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
                            aItem.push(data[field]);
                        }
                    );
                    aItem.push(fcms.fnFormatDate(data['created_at']));
                    aItem.push(fcms.fnFormatDate(data['updated_at']));

                    oTable.fnUpdate(aItem, fcms.fnGetSelected(oTable)[0]);

                    fcms.fnClearForm();
                    oTable.$('tr.row_selected').removeClass('row_selected');

                    fcms.showMessage('L\'item a été modifié avec succès.');
                },
                error   : function( xhr, err ) {
                    fcms.showMessage('L\'item n\'a pas été ajouté');
                }
            });
        }
        // Add item
        else {
            if (type == 1 || type == 3) {
                $.ajax({
                    url     : modelUrl,
                    type    : 'post',
                    dataType: 'json',
                    data    : oForm.serialize(),
                    success : function( data ) {
                        var aItem = new Array();

                        $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
                            function(){
                                var field = $(this).attr('id').replace(/^[a-zA-Z0-9]+_/g, '');
                                aItem.push(data[field]);
                            }
                        );

                        aItem.push(fcms.fnFormatDate(data['created_at']));
                        aItem.push(fcms.fnFormatDate(data['updated_at']));

                        var iRow = oTable.fnAddData(aItem);

                        $(oTable.fnGetNodes(iRow)).click( fcms.fnSelectableRows );

                        fcms.fnClearForm();

                        fcms.showMessage('L\'item a été ajouté avec succès.');

                        oTable.$('tr.row_selected').removeClass('row_selected');
                    },
                    error   : function( xhr, err ) {
                        fcms.showMessage('L\'item n\'a pas été ajouté');
                    }
                });
            }
        }
        return false;
    });

};

fcms.dataTables.initTable = function () {
    // Init the table
    oTable = $(oTable).dataTable({
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
};

// Selectable rows
fcms.dataTables.fnSelectableRows = function ( e ) {
    if ($(this).hasClass('row_selected')) {
        $(this).removeClass('row_selected');
        if (oForm) {
            fcms.dataTables.fnClearForm();
        }
    }
    else {
        oTable.$('tr.row_selected').removeClass('row_selected');
        $(this).addClass('row_selected');

        // If we have a form bound to the dataTables, fill in the values
        if(oForm) {
            var id = $(this).children().first().text();

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
    }
};

// Clear the form
fcms.dataTables.fnClearForm = function () {
    if (oForm) {
        $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
            function(){
                $(this).val('');
            }
        );
    }
};

// Get the rows which are currently selected
fcms.dataTables.fnGetSelected = function ( oTableLocal ) {
    return oTableLocal.$('tr.row_selected');
};