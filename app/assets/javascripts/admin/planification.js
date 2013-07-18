//= require datatables
//= require dataTables/extras/TableTools

var dataTableOptions = {
    "bPaginate": false,
    "bInfo": false,
    "sScrollY": 200,
    "sScrollX": "100%"
};

function loadTimeslot(data) {
    data = data || {
        id: -1,
        category_id: fcms.currentCategory.id,
        duration: 0,
        label: "",
        registrations: []
    };
    fcms.currentTimeslot = data;

    var tables = ["all", "selected"];

    // Create the tables and their headers
    for (var t in tables) {
        var table = $('<table></table>').addClass('table table-bordered table-inscriptions')
            .attr('id', 'table-inscriptions-' + tables[t]);
        $('#div-inscriptions-' + tables[t]).empty().append(table);

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
            for (var r = 0; r < fcms.currentTimeslot.registrations.length; r++)
                tbody.append(createTableRow(fcms.currentTimeslot.registrations[r]));
        }

        // Initialize DataTables
        fcms.bindTable('#table-inscriptions-' + tables[t]);
        fcms.initTable(dataTableOptions);

        // Hide last "row-fluid" thingy and resizable function
        var wrapper = oTable.parents('.dataTables_wrapper');
        wrapper.find('.row-fluid:last').remove();
        wrapper.after('<div class="table-dragger" data-for-table="table-inscriptions-all"><i class="icon-ellipsis-horizontal"></i></div>')
    }

    // Add/remove selection on table row click
    $('.dataTable').on('click', 'tbody tr', function(e) {

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
        return $('<tr></tr>').append('<th>Id</th>')
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