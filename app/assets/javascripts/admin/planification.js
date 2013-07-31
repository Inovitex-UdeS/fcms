//= require datatables
//= require dataTables/extras/TableTools

// Global variable to store the current category
fcms.currentCategory = [];

// DataTables options for registrations tables
var regDTOptions = {
    "bPaginate": false,
    "bInfo": false,
    "sScrollY": 200,
    "sScrollX": "100%",
    "oLanguage": {},
    "fnCreatedRow": function(row) {
        $(row).addClass('draggable');
    }
};

// DataTables options for timeslots table
var tsDTOptions = {
    "bPaginate": false,
    "sScrollX": "",
    "oLanguage": {
        "sEmptyTable": "Aucune plage horaire n'a encore été ajoutée pour cette classe d'inscriptions."
    },
    "fnCreatedRow": function(row) {
        $(row).addClass('selectable');
    }
};

$(document).ready(function() {
    // Hide the planification section
    $('#section-2').hide();

    // On category selection
    $('#input-planned-category').on('change', function() {
        var selectedOption = $(this).children("option:selected");
        var categoryId = selectedOption.attr('value');
        if (!categoryId || categoryId < 0)
            $('#section-2').hide('fast');
        else
            ajaxLoadCategory(categoryId);
    });

    // Enable select-all and select-none buttons
    $('#btn-select-all-down')     .click(function() { $('#table-inscriptions-selected tr.draggable').addClass('selected'); });
    $('#btn-select-none-down')    .click(function() { $('#table-inscriptions-selected tr.draggable').removeClass('selected'); });

    $('#btn-select-all-up')       .click(function() { $('#table-inscriptions-all      tr.draggable').addClass('selected'); });
    $('#btn-select-none-up')      .click(function() { $('#table-inscriptions-all      tr.draggable').removeClass('selected'); });

    // Enable arrow buttons
    $('#btn-move-all-down')       .click(function() { moveRows($('#table-inscriptions-selected tr.draggable'),          fcms.table_selected, fcms.table_all); });
    $('#btn-move-selected-down')  .click(function() { moveRows($('#table-inscriptions-selected tr.draggable.selected'), fcms.table_selected, fcms.table_all); });
    $('#btn-move-all-up')         .click(function() { moveRows($('#table-inscriptions-all      tr.draggable'),          fcms.table_all, fcms.table_selected); });
    $('#btn-move-selected-up')    .click(function() { moveRows($('#table-inscriptions-all      tr.draggable.selected'), fcms.table_all, fcms.table_selected); });

    // Enable save timeslot button
    $('#btn-save-timeslot').click(saveTimeslot);
});

// Load a category in memory and displays each timeslots in a table
function loadCategory(data) {
    fcms.currentCategory = data;

    var container = $('#div-timeslots').empty();

    var table = $('<table></table>').addClass('table table-bordered')
        .attr('id', 'table-timeslots').appendTo(container);

    var thead = $('<thead></thead>').appendTo(table)
    createTimeslotRow().appendTo(thead);

    var tbody = $('<tbody></tbody>').appendTo(table);
    _.each(fcms.currentCategory.timeslots, function(ts) {
        createTimeslotRow(ts).appendTo(tbody)
    });

    fcms.bindTable(table);
    fcms.initTable(tsDTOptions);
    fcms["table_timeslots"] = oTable;

    // On click event
    table.on('click', 'tr.selectable', function(e) {
        if (!$(this).hasClass('row_selected')) {
            table.find('tr.selectable').removeClass('row_selected');
            $(this).addClass('row_selected');

            var timeslot_id = $(this).children('td')[0].innerHTML;

            ajaxLoadTimeslot(timeslot_id);
        }
        else {
            $(this).toggleClass('row_selected');
            $('.panel:not(#panel-categories)').hide('fast');
        }
    });

    // Append add/remove buttons
    var btnAdd = $('<button></button>').attr('id', 'btn-add-timeslot')
        .addClass('btn btn-primary btn-small')
        .html('<i class="icon-plus"></i> Ajouter une plage horaire')
        .click(function() {
            table.find('tr.selectable').removeClass('row_selected');
            loadTimeslot()
        });
    var btnRmv = $('<button></button>').attr('id', 'btn-remove-timeslot')
        .addClass('btn btn-small')
        .html('<i class="icon-minus"></i> Supprimer')
        .click(function() {
            var row = table.find('tr.selectable.row_selected')[0];
            var tsId = parseInt(row.children[0].innerHTML);
            ajaxRemoveTimeslot(tsId, row);
        });
    container.find('.row-fluid:last > .span6:first').append(btnAdd).append('&nbsp;&nbsp;').append(btnRmv);

    // Add the category name everywhere
    $('#panel-categories').children('h4').html('Plages horaires pour la classe <b>' + data.name + '</b>');
    $('#panel-all').children('h4').html('Inscriptions non-planifiées pour la classe <b>' + data.name + '</b>');
}

// Create a row for the timeslot in the category table
function createTimeslotRow(timeslot) {
    if (!timeslot) {
        return $('<tr></tr>')
            .append('<th>#</th>')
            .append('<th>Nom</th>')
            .append('<th>Nb inscriptions</th>')
            .append('<th>Durée</th>')
            .append('<th>Date de création</th>')
            .append('<th>Dernière mise à jour</th>');
    }
    else {
        return $('<tr></tr>').append('<td>' + getTimeslotObjectForRow(timeslot).join('</td><td>') + '</td>')
    }
}

// Get an array representing the columns of a timeslot in the timeslot table
function getTimeslotObjectForRow(timeslot) {
    return [
        timeslot.id,
        timeslot.label,
        timeslot.registrations.length,
        timeslot.duration,
        timeslot.created_at,
        timeslot.updated_at
    ];
}

// Load a timeslot and generates the timeslot editor
function loadTimeslot(data) {
    // Process timeslot data
    data = data || { registrations: [] };
    fcms.currentTimeslot = data;

    // Show the timeslot panel
    $('.panel:not(#panel-categories)').show('fast');

    // Update text controls
    $('#input-timeslot-id').val(data.id);
    $('#input-timeslot-name').val(data.label);

    // Create the tables and their headers
    var tables = ["all", "selected"];
    var messages = [
        "Toutes les inscriptions pour cette classe ont déjà été assignées à une plage horaire.",
        "Aucune inscription n'a été assignée à cette plage horaire."
    ];
    for (var t in tables) {
        var container = $('#div-inscriptions-' + tables[t]).empty();

        var table = $('<table></table>').addClass('table table-bordered table-clear table-inscriptions')
            .attr('id', 'table-inscriptions-' + tables[t]).appendTo(container);

        var thead = $('<thead></thead>').appendTo(table);
        thead.append(createRegistrationRow());

        var tbody = $('<tbody></tbody>').appendTo(table);
        if (tables[t] == "all") {
            for (var r = 0; r < fcms.currentCategory.registrations.length; r++) {
                var reg = fcms.currentCategory.registrations[r];
                if (reg && !reg.timeslot_id) {
                    tbody.append(createRegistrationRow(r));
                }
            }
        }
        else if (tables[t] == "selected") {
            for (var r = 0; r < data.registrations.length; r++)
                tbody.append(createRegistrationRow(data.registrations[r]));
        }

        // Set table options
        regDTOptions.oLanguage.sEmptyTable  = messages[t];

        // Initialize DataTables
        fcms.bindTable('#table-inscriptions-' + tables[t]);
        fcms.initTable(regDTOptions);
        fcms["table_"+tables[t]] = oTable;

        // Hide last "row-fluid" thingy
        oTable.parents('.dataTables_wrapper').find('.row-fluid:last').remove();

        // Add table
        $('<div class="table-footer"></div>')
            .append('<span class="tablestat-nbreg"></span>')
            .append('<span class="tablestat-duration"></span>')
            .appendTo(container);

        // Add table resizer
        $('<div class="table-dragger"></div>')
            .attr("data-for-table", "table-inscriptions-" + tables[t])
            .append('<i class="icon-ellipsis-horizontal"></i>')
            .on('mousedown', resizeTable)
            .appendTo(container);
    }
    refreshTableFooters();

    // Add/remove selection on table row click
    $('.dataTable').on('click', 'tr.draggable', function() {
        $(this).toggleClass('selected');
    });
}

// Create a row in a registrations table
function createRegistrationRow(regId) {
    if (!regId || regId < 0) {
        return $('<tr></tr>')
            .append('<th>#</th>')
            .append('<th>Classe</th>')
            .append('<th>Instrument</th>')
            .append('<th>Nom</th>')
            .append('<th>Prénom</th>')
            .append('<th>Âge</th>')
            .append('<th>Compositeur(s)</th>')
            .append('<th>Pièce(s)</th>')
            .append('<th>Durée</th>');
    }
    else {
        var reg = fcms.currentCategory.registrations[regId];
        if (!reg) return;

        var regInstr = [], regLast = [], regFirst = [];
        for (var u in reg.users) {
            regInstr.push(reg.users[u].instrument);
            regLast.push(reg.users[u].last_name);
            regFirst.push(reg.users[u].first_name);
        }

        var regCmp = [], regTitle = [];
        for (var p in reg.performances) {
            regCmp.push(reg.performances[p].composer);
            regTitle.push(reg.performances[p].title);
        }

        return $('<tr></tr>')
            .append('<td>' + regId                   + '</td>')
            .append('<td>' + reg.category            + '</td>')
            .append('<td>' + regInstr.join('<br />') + '</td>')
            .append('<td>' + regLast.join('<br />')  + '</td>')
            .append('<td>' + regFirst.join('<br />') + '</td>')
            .append('<td>' + reg.age                 + '</td>')
            .append('<td>' + regCmp.join('<br />')   + '</td>')
            .append('<td>' + regTitle.join('<br />') + '</td>')
            .append('<td>' + reg.duration + '</td>');
    }
}

// Updates the number of registrations and total duration of a registrations table
function refreshTableFooters()  {
    $('.div-inscriptions').each(function(i, wrapper) {
        var rows = $(wrapper).find('.table-inscriptions tr.draggable');

        var nbInscriptions = (rows.length || 0);
        var duration = 0;

        rows.each(function(r, row) {
            var id = parseInt(row.children[0].innerHTML);
            duration += (id < 0 ? 0 : fcms.currentCategory.registrations[id].duration);
        });

        $(wrapper).find('.table-footer').text(
            nbInscriptions + " inscription" + (nbInscriptions > 1 ? "s":"") +
            (duration > 1 ? ", " + duration + " minutes" : "")
        );
    });
}

// Move rows from a table to another
function moveRows(rows, src, dst) {
    var data = [];
    rows.each(function(i,row) {
        data[i] = [];
        _.each(row.cells, function(td) {
            data[i].push(td.innerHTML);
        });
        src.fnDeleteRow(row);
    });
    dst.fnAddData(data);
    refreshTableFooters();
}

// Mouse table draggers
function resizeTable(e) {
    var id = $(this).data('for-table');
    var tbody = $('#'+id).parent('.dataTables_scrollBody');

    var sH = tbody.height();
    var sX = e.pageY;

    $(document).on('mouseup', function(me){
        $(document).off('mouseup').off('mousemove');
    });

    $(document).on('mousemove', function(me){
        tbody.height(sH - (sX - me.pageY));
    });
}

// Save a timeslot
function saveTimeslot() {
    // Build the save object
    obj = {};

    obj.id = parseInt($('#input-timeslot-id').val()) || -1;
    obj.label = $('#input-timeslot-name').val();
    obj.category_id = fcms.currentCategory.id;

    // Get registrations from table-inscriptions-selected
    obj.registrations = [];
    $('#table-inscriptions-selected tr.draggable').each(function(r, row) {
        obj.registrations.push(parseInt(row.children[0].innerHTML));
    });

    ajaxSaveTimeslot(obj);
}

// Clear all previous registrations for the specified category
function clearRegistrations(id) {
    for (var r in fcms.currentCategory.registrations) {
        var reg = fcms.currentCategory.registrations[r];
        if (reg && reg.timeslot_id == id) {
            reg.timeslot_id = null;
        }
    }
}

// AJAX request to load a category with all its registrations
function ajaxLoadCategory(category_id) {
    $.ajax({
        url: fcms.planificationURL + category_id,
        success: function(data) {
            $('.panel:not(#panel-categories)').hide();
            $('#section-2').show('fast');

            loadCategory(data);
        },
        error: function() {
            alert("Les sous-catégories pour la classe " + category_id + " n'ont pas pu être chargées.")
        }
    })
}

// AJAX request to load a specific timeslot associated to the selected category
function ajaxLoadTimeslot(timeslot_id) {
    $.ajax({
        url: fcms.timeslotURL + timeslot_id,
        success: function(data) {
            loadTimeslot(data);
        },
        error: function() {
            alert("La sous-catégorie " + timeslot_id + " n'a pas pu être chargée.");
        }
    });
}

// AJAX request to save the current timeslot
function ajaxSaveTimeslot(obj) {
    $.ajax({
        url: fcms.timeslotURL,
        type: "POST",
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify(obj),
        success: function(data) {
            clearRegistrations(obj.id);

            // Put all current registrations in this timeslot
            for (var r in obj.registrations)
                fcms.currentCategory.registrations[obj.registrations[r]].timeslot_id = data.id;

            if (obj.id < 0) {
                $('#input-timeslot-id').val(data.id);
                var index = fcms["table_timeslots"].fnAddData(getTimeslotObjectForRow(data));
                fcms["table_timeslots"].find('tr.selectable:eq(' + index[0] + ')').addClass('row_selected');
            }
            else {
                fcms["table_timeslots"].fnUpdate(getTimeslotObjectForRow(data), fcms.fnGetSelected(fcms["table_timeslots"])[0]);
            }

            fcms.showMessage("Les modifications ont été enregistrées.");
        },
        error: function() {
            fcms.showMessage("Les modifications n'ont pas pu être enregistrées.", "error");
        }
    })
}

// AJAX request to delete a timeslot
function ajaxRemoveTimeslot(tsId, row) {
    $.ajax({
        url: fcms.timeslotURL + tsId,
        type: "DELETE",
        success: function() {
            fcms["table_timeslots"].fnDeleteRow(row);
            $('.panel:not(#panel-categories)').hide('fast');
            fcms.showMessage("La catégorie a été supprimée avec succès.");
        },
        error: function() {
            fcms.showMessage("La catégorie n'a pas pu être supprimée.", "error");
        }
    })
}