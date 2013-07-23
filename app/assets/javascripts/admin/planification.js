//= require datatables
//= require dataTables/extras/TableTools

var dataTableOptions = {
    "bPaginate": false,
    "bInfo": false,
    "sScrollY": 200,
    "sScrollX": "100%",
    "fnCreatedRow": function(row) {
        $(row).addClass('draggable');
    }
};

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
    for (var t in tables) {
        var container = $('#div-inscriptions-' + tables[t]);

        var table = $('<table></table>').addClass('table table-bordered table-inscriptions')
            .attr('id', 'table-inscriptions-' + tables[t]);
        container.empty().append(table);

        var thead = $('<thead></thead>').appendTo(table);
        thead.append(createTableRow());

        var tbody = $('<tbody></tbody>').appendTo(table);
        if (tables[t] == "all") {
            for (var r = 0; r < fcms.currentCategory.registrations.length; r++) {
                var reg = fcms.currentCategory.registrations[r];
                if (reg && !reg.timeslot_id) {
                    tbody.append(createTableRow(r));
                }
            }
        }
        else if (tables[t] == "selected") {
            for (var r = 0; r < data.registrations.length; r++)
                tbody.append(createTableRow(data.registrations[r]));
        }

        // Initialize DataTables
        fcms.bindTable('#table-inscriptions-' + tables[t]);
        fcms.initTable(dataTableOptions);
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

    // Add save timeslot button
    $('#btn-save-timeslot').click(saveTimeslot);
    $('#btn-remove-timeslot').click(function() { alert("Cette fonctionnalité n'est pas encore implémentée.", "alert") });

    // Add/remove selection on table row click
    $('.dataTable').on('click', 'tr.draggable', function(e) {

        // Toggle tde clicked element
        $(this).toggleClass('selected');

        // If shift key is down, toggle elements before and after
        if (e.shiftKey) {
            var selected = $(this).hasClass('selected');
            var filter = selected ? '.selected' : ':not(.selected)';
            var allRows = $(this).parent('tbody').children('tr');

            // Toggle rows from top to current
            var first = $(this).prevAll('tr'+filter).last().index();
            if (first > -1) {
                for (var i = $(this).index(allRows)-1; i >= first; i--)
                    allRows.eq(i).toggleClass('selected');
            }

            // Toggle rows from current to bottom
            var last = $(this).nextAll('tr'+filter).first().index();
            if (last > -1) {
                for (var i = $(this).index(allRows)+1; i <= last; i++)
                    allRows.eq(i).toggleClass('selected');
            }

            // Prevent mouse selection
            // TODO: MAKE SURE THIS WORKS
            if(e.stopPropagation) e.stopPropagation();
            if(e.preventDefault) e.preventDefault();
            e.cancelBubble=true;
            e.returnValue=false;
            return false;
        }
    });
}

function createTableRow(regId) {
    if (!regId || regId < 0) {
        return $('<tr></tr>').append('<th>#</th>')
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

        return $('<tr></tr>').append('<td>' + regId                   + '</td>')
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

    // Post to application
    $.ajax({
        url: "http://localhost:3000/admin/planification/timeslots/",
        type: "POST",
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify(obj),
        success: function(data) {
            // Clear all previous registrations for this category
            for (var r in fcms.currentCategory.registrations) {
                var reg = fcms.currentCategory.registrations[r];
                if (reg && reg.timeslot_id == obj.id) {
                    reg.timeslot_id = null;
                }
            }

            // Put all current registrations in this timeslot
            for (var r in obj.registrations)
                fcms.currentCategory.registrations[obj.registrations[r]].timeslot_id = data.id;

            fcms.showMessage("Les modifications ont été enregistrées.");
        },
        error: function() {
            fcms.showMessage("Les modifications n'ont pas pu être enregistrées.", "error");
        }
    })
}