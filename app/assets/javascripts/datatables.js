// Datatables and plugins
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap

var oTable;
var oForm;
var modelName;
var modelUrl;
var re;

fcms.bindTable = function (table) {
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
//   - 4 For add, edit & remove buttons
// ALWAYS CALL BINDFORM AFTER INITTABLE
fcms.bindForm = function (form, type) {

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
        $(this).single_double_click(fcms.fnSelectableRows, fcms.fnEditableRows);
    });

    var htmlToInput = '';

    switch(type)
    {
        case 1:
            htmlToInput = '<a id="addItem" class="btn btn-primary btn-small" href="#" onclick="$(\'#formModal\').modal(\'show\')"><i class="icon-plus"></i> Ajouter</a>';
            break;
        case 2:
            htmlToInput = '<a id="deleteItem" class="btn btn-small" href="#"><i class="icon-remove"></i> Supprimer</a></div>';
            break;
        case 3:
            htmlToInput = '<a id="addItem" class="btn btn-primary btn-small" href="#" onclick="$(\'#formModal\').modal(\'show\')"><i class="icon-plus"></i> Ajouter</a><a id="deleteItem" class="btn btn-small" href="#"><i class="icon-remove"></i> Supprimer</a></div>';
            break;
        case 4:
            htmlToInput = '<a id="addItem" class="btn btn-primary btn-small" href="#" onclick="$(\'#formModal\').modal(\'show\')"><i class="icon-plus"></i> Ajouter</a><a id="editItem" class="btn btn-small" href="#"><i class="icon-pencil"></i> Modifier</a><a id="deleteItem" class="btn btn-small" href="#"><i class="icon-remove"></i> Supprimer</a></div>';
            break;
    }

    // Add a + and/or - button
    $('.row-fluid:last > .span6:first').html(htmlToInput);

    // Add button section
    if(type == 1 || type == 3 || type == 4){
        // Prevent scrolling top when clicking on button
        $('#addItem').click(function(e){ e.preventDefault(); $.get(modelUrl) });

        // Add click handler (will clear the form)
        $('#addItem').click( function() {
            oTable.$('tr.row_selected').removeClass('row_selected');
            fcms.fnClearForm();
        });
    }

    // Delete button section
    if(type == 2 || type == 3 || type == 4){
        // Prevent scrolling top
        $('#deleteItem').click(function(e){ e.preventDefault(); $.get(modelUrl) });

        // Add a click handler for the delete button
        $('#deleteItem').click( function() {
            var anSelected = fcms.fnGetSelected( oTable );
            if ( anSelected.length !== 0 ) {
                var id = oTable.fnGetData(oTable.fnGetPosition(anSelected[0]))[0];
                fcms.confirm(function(){
                    $.ajax({
                        url: modelUrl + id,
                        type: 'DELETE',
                        success: fcms.fnSuccessRemoveData,
                        error: function( xhr, err ) {
                            fcms.showMessage($.parseJSON(xhr.responseText)['message'], 3);
                        }
                    });
                });
            }
        });
    }

    // Edit button section
    if(type == 4){
        // Add click handler (will open editor)
        $('#editItem').click( function(e) {
            $('tr.row_selected').eq(0).each(function() {
                fcms.fnEditableRows.call(this, event);
            });

            e.preventDefault();
        });
    }

    // Add ajax callbacks
    $('#formSave').click(function(){
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
                success : fcms.fnSuccessUpdateData,
                error   : function( xhr, err ) {
                    fcms.showMessage($.parseJSON(xhr.responseText)['message'], 3);
                }
            });
        }
        // Add item
        else {
            if (type == 1 || type == 3 || type == 4 ) {
                $.ajax({
                    url     : modelUrl,
                    type    : 'post',
                    dataType: 'json',
                    data    : oForm.serialize(),
                    success : fcms.fnSuccessAddItem,
                    error   : function( xhr, err ) {
                        fcms.showMessage($.parseJSON(xhr.responseText)['message'], 3);
                    }
                });
            }
        }
        return false;
    });
};

fcms.mergeObjects = function(obj1, obj2) {
    if (obj2)
        for (var i in obj2) {
            if (obj1[i] != null && typeof obj1[i] === 'object')
                fcms.mergeObjects(obj1[i], obj2[i]);
            else obj1[i] = obj2[i];
        }
    return obj1;
}

fcms.initTable = function (customSettings) {
    // Init the table
    oTable = $(oTable).dataTable(fcms.mergeObjects({
        "bInfo": false,
        "sScrollX": "98%",
        "bScrollCollapse": true,
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
    }, customSettings));

    // Update search box styling
    var filterDiv = oTable.parents('.dataTables_wrapper:first').find('.dataTables_filter');
    var contents = $('<div class="input-prepend"></div>')
        .append('<span class="add-on"><i class="icon-search"></i></span>')
        .append(filterDiv.find('input').attr('id', 'datatables-search'));
    filterDiv.html('').append(contents).css({
        textAlign: "right",
        marginBottom: 5
    });

    // Add tooltips for column headers
    oTable.find('th').each( function() {
        $(this).tooltip({
            'title': $(this).text(),
            'container': 'body'
        });
    });
};

fcms.fnEditableRows = function ( e ) {
    oTable.$('tr.row_selected').removeClass('row_selected');
    $(this).addClass('row_selected');

    // If we have a form bound to the fcms, fill in the values
    if(oForm) {
        var id = $(this).children().first().text();

        $.ajax({
            url     : modelUrl + id,
            type    : 'GET',
            dataType: 'json',
            success : fcms.fnSuccessGetData
        });
    }
};

// Single click - Selectable rows
fcms.fnSelectableRows = function ( e ) {
    if ($(this).hasClass('row_selected')) {
        $(this).removeClass('row_selected');
        if (oForm) {
            fcms.fnClearForm();
        }
    }
    else {
        oTable.$('tr.row_selected').removeClass('row_selected');
        $(this).addClass('row_selected');
    }
};

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

    oTable.fnUpdate(aItem, fcms.fnGetSelected(oTable)[0]);

    fcms.fnClearForm();
    oTable.$('tr.row_selected').removeClass('row_selected');

    fcms.showMessage('L\'item a été modifié avec succès.');
};

fcms.fnSuccessGetData = function( data ) {
    $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
        function(){
            var field = $(this).attr('id').replace(modelName + "_", "");
            if (field in data) {
                $(this).val(data[field]);
            }
        }
    );
    $('#formModal').modal('show');
};


fcms.fnSuccessRemoveData = function(result) {
    var selected = fcms.fnGetSelected( oTable );
    fcms.showMessage('L\'item a été supprimé avec succès');
    oTable.fnDeleteRow(selected[0]);
    fcms.fnClearForm();
};

// Clear the form
fcms.fnClearForm = function () {
    if (oForm) {
        oForm[0].reset();
    }
};

// Get the rows which are currently selected
fcms.fnGetSelected = function ( oTableLocal ) {
    return oTableLocal.$('tr.row_selected');
};

// Inject a single delete button
fcms.fnInjectDeleteButton = function (deletePath, select) {

    // Add trailing / if not there
    if(!/\/$/.test(deletePath))
        deletePath += '/';

    // Add a click handler to the rows (selectable rows)
    $.each(oTable.fnGetNodes(), function() {
        $(this).click( fcms.fnSelectableRows );
    });

    // Add  - button
    $('.row-fluid:last > .span6:first').html('<a id="deleteItem" class="btn btn-primary btn-small" href="#"><i class="icon-minus"></i> Supprimer</a></div>');

    // Prevent scrolling top
    $('#deleteItem').click(function(e){ e.preventDefault(); $.get(deletePath) });

    // Add a click handler for the delete button
    $('#deleteItem').click( function() {
        var anSelected = fcms.fnGetSelected( oTable );
        if ( anSelected.length !== 0 ) {
            var id = oTable.fnGetData(oTable.fnGetPosition(anSelected[0]))[0];
            var nameEmail = oTable.fnGetData(oTable.fnGetPosition(anSelected[0]))[1] + ' (' + oTable.fnGetData(oTable.fnGetPosition(anSelected[0]))[2] + ')' ;
            fcms.confirm(function(){
                $.ajax({
                    url: deletePath + id,
                    type: 'DELETE',
                    complete: function(result) {
                        oTable.fnDeleteRow(anSelected[0]);

                        fcms.showMessage('L\'item a été supprimé avec succès');

                        select.append($('<option>', {
                            value: id,
                            text: nameEmail
                        }));

                        select.data('typeahead').source[id] = nameEmail;
                    }
                });
            });
        }
    });
};

// Confirm modal window for all basic forms
fcms.confirm = function(callback) {

    var confirmModal =
        $('<div class="modal hide fade">' +
            '<div class="modal-header">' +
            '<a class="close" data-dismiss="modal" >&times;</a>' +
            '<h3>Êtes-vous sûr de vouloir supprimer l\'item sélectionné?</h3>' +
            '</div>' +

            '<div class="modal-body">' +
            '<p style="text-align:justify">' + 'Vous pouvez supprimer définitivement des objets de base de données sélectionnés. '
                  + 'Cette suppression supprime les objets de la base de données. '
                  + 'Ils ne seront plus énumérés dans l\'application web. '
                  + 'Il se peut qu\'une contrainte de clé étrangère soit appliquée à certains des objets sélectionnés, ce qui empêche la suppression. '
                  + 'Dans cette situation, veuillez supprimer en premier temps les références et ensuite, recommencer cette suppression. ' +
            '</p>' +
            '</div>' +

            '<div class="modal-footer">' +
            '<a href="#" class="btn" data-dismiss="modal">' +
                'Fermer' +
            '</a>' +
            '<a href="#" id="okButton" class="btn btn-primary">' +
                'Supprimer' +
            '</a>' +
            '</div>' +
            '</div>');

    confirmModal.find('#okButton').click(function(event) {
        callback();
        confirmModal.modal('hide');
    });

    confirmModal.modal('show');
};

// Confirm modal window for delete registrations
fcms.confirmRegDel = function (obj) {

    var confirmModal =
        $('<div class="modal hide fade">' +
            '<div class="modal-header">' +
            '<a class="close" data-dismiss="modal" >&times;</a>' +
            '<h3>' + 'Êtes-vous sûr de vouloir supprimer l\'inscription?' +'</h3>' +
            '</div>' +

            '<div class="modal-body">' +
            '<p>' + 'En appuyant sur le bouton supprimer, vous allez annuler votre inscription pour cette édition du Festival Concours de Musique de Sherbrooke.' + '</p>' +
            '</div>' +

            '<div class="modal-footer">' +
            '<a href="#" id="cancelButton" class="btn" data-dismiss="modal">' +
            'Fermer' +
            '</a>' +
            '<a href="#" id="okButton" class="btn btn-primary">' +
            'Supprimer' +
            '</a>' +
            '</div>' +
            '</div>');

    confirmModal.find('#okButton').click(function(event) {
        window.location = obj.attr('href');
        confirmModal.modal('hide');
    });

    confirmModal.modal('show');
};
