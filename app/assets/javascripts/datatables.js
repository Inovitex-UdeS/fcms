// Datatables and plugins
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap

var oTable;
var oForm;
var modelName;
var modelUrl;
var re;

fcms.initTable = function (form) {

    // Copy the form
    oForm = form;

    // Copy the form url for further usage
    modelUrl = $(oForm).attr('action');
    if(!/\/$/.test(modelUrl))
        modelUrl += '/';

    // Find the modelName out of the id
    modelName = $(oForm).attr('id').replace(/[a-zA-Z0-9]+_/g, '');

    // Create regular expression to find inputs
    re = new RegExp(modelName + '.*', 'g');

    // Add a click handler to the rows - this could be used as a callback
    $(".table tbody tr").click( fcms.fnSelectableRows );

    // Init the table
    oTable = $('.table').dataTable({
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

    // Add a + and - button
    $('.row-fluid:last > .span6:first').html('<a id="addItem" class="btn btn-primary btn-grid" href="#">Ajouter</a><a id="deleteItem" class="btn" href="#">Supprimer</a></div>');

    // Prevent scrolling top
    $('#deleteItem').click(function(e){ e.preventDefault(); $.get(modelUrl) });
    $('#addItem').click(function(e){ e.preventDefault(); $.get(modelUrl) });

    // Add a click handler for the delete button
    $('#deleteItem').click( function() {
        var anSelected = fcms.fnGetSelected( oTable );
        if ( anSelected.length !== 0 ) {
            anSelected = $(anSelected);
            var id = anSelected.children().first().text();
            $.ajax({
                url: modelUrl + id,
                type: 'DELETE',
                complete: function(result) {
                    oTable.fnDeleteRow(anSelected[0]);
                    fcms.fnClearForm();
                }
            });
        }
    } );

    // Add a click handler for the add button
    $('#addItem').click( function() {
        oTable.$('tr.row_selected').removeClass('row_selected');
        fcms.fnClearForm();
    });

    // Add ajax callbacks
    $("input[type=submit]",oForm).click(function(){
        var formId;

        $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(/.*_id/g); }).each(
            function(){
                formId = $(this);
            }
        );

        if(formId.val()) {

            $.ajax({
                url     : modelUrl + formId.val(),
                type    : 'put',
                dataType: 'json',
                data    : oForm.serialize(),
                success : function( data ) {
                    var selectedRowColumn = fcms.fnGetSelected(oTable).children().first();

                    $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
                        function(){
                            var field = $(this).attr('id').replace(/[a-zA-Z0-9]+_/g, '');
                            selectedRowColumn.text(data[field]);
                            selectedRowColumn = selectedRowColumn.next();
                        }
                    );
                    selectedRowColumn.text(fcms.fnFormatDate(data['created_at']));
                    selectedRowColumn = selectedRowColumn.next();
                    selectedRowColumn.text(fcms.fnFormatDate(data['updated_at']));

                    fcms.fnClearForm();
                    oTable.$('tr.row_selected').removeClass('row_selected');

                    fcms.showMessage('L\'item a été modifié avec succès.')
                },
                error   : function( xhr, err ) {
                    fcms.showMessage('L\'item n\'a pas été ajouté')
                }
            });
        }
        else {
            $.ajax({
                url     : modelUrl,
                type    : 'post',
                dataType: 'json',
                data    : oForm.serialize(),
                success : function( data ) {
                    var aItem = new Array();

                    $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
                        function(){
                            var field = $(this).attr('id').replace(/[a-zA-Z0-9]+_/g, '');
                            aItem.push(data[field]);
                        }
                    );

                    aItem.push(fcms.fnFormatDate(data['created_at']));
                    aItem.push(fcms.fnFormatDate(data['updated_at']));

                    var iRow = oTable.fnAddData(aItem);

                    $('table tbody tr:nth-child(' + (iRow[0]+1) + ')' ).click( fcms.fnSelectableRows );

                    fcms.fnClearForm();

                    fcms.showMessage('L\'item a été ajouté avec succès.')
                },
                error   : function( xhr, err ) {
                    fcms.showMessage('L\'item n\'a pas été ajouté')
                }
            });
        }
        return false;
    });
};

// Selectable rows
fcms.fnSelectableRows = function ( e ) {
    if ($(this).hasClass('row_selected')) {
        $(this).removeClass('row_selected');
        fcms.fnClearForm();
    }
    else {
        oTable.$('tr.row_selected').removeClass('row_selected');
        $(this).addClass('row_selected');

        var rowChildren = $(this).children().first();

        $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
            function(){
                $(this).val(rowChildren.text());
                rowChildren = rowChildren.next();
            }
        );
    }
};

// Clear the form
fcms.fnClearForm = function () {
    $('#' + oForm.attr('id') + ' input').filter(function() { return this.id.match(re); }).each(
        function(){
            $(this).val('');
        }
    );
};

// Get the rows which are currently selected
fcms.fnGetSelected = function ( oTableLocal ) {
    return oTableLocal.$('tr.row_selected');
};