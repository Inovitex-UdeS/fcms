//= require datatables
//= require dataTables/extras/TableTools

var ageGroupTableFields = [
    { "name": "id",           "type": "number",  "description": "#",                   "class": "input-small",  "suffix": "",   "disabled": true },
    { "name": "description",  "type": "text",    "description": "Description",         "class": "input-small2", "suffix": ""  },
    { "name": "min",          "type": "number",  "description": "Âge minimal",         "class": "input-small",  "suffix": " ans"  },
    { "name": "max",          "type": "number",  "description": "Âge maximal",         "class": "input-small",  "suffix": " ans"  },
    { "name": "fee",          "type": "number",  "description": "Tarif d'inscription", "class": "input-small",  "suffix": " $"  },
    { "name": "max_duration", "type": "number",  "description": "Durée maximale",      "class": "input-small",  "suffix": " minutes"  }
];

$(document).ready(function() {
    // Find the category form
    fcms.formCategory = $('form#new_category');
    
    // Copy the form URL for further usage
    fcms.categoryURL = fcms.formCategory.attr('action');
    if(!/\/$/.test(fcms.categoryURL)) fcms.categoryURL += '/';

    // Initialize DataTables
    initCategoriesTable();
    initAgeGroupTable();

    // Hide the category form
    fcms.formCategory.hide();
});

// Initialize the categories table and bind everything
function initCategoriesTable() {
    // Bind to class table
    fcms.bindTable('#classes_list');
    fcms.initTable({
        "oLanguage": {
            "sEmptyTable": "Aucune classe n'existe pour le moment."
        },
        "fnCreatedRow": function(row) {
            $(row).addClass('selectable');
        }
    });
    fcms.tableCategories = oTable;

    // Add 'Add' and 'Delete' buttons to categories table
    $('#classes_list_wrapper .row-fluid:last .span6:first').html(
        "<a id='categories_addItem' class='btn btn-primary btn-small' href='#'><i class='icon-plus'></i> Ajouter</a>&nbsp;<a id='categories_deleteItem' class='btn btn-small' href='#'><i class='icon-remove'></i> Supprimer</a></div>"
    );

    // On click event
    fcms.tableCategories.on('click', 'tr.selectable', function(e) {
        if (!$(this).hasClass('row_selected')) {
            // Clear all selected rows
            fcms.tableCategories.find('tr.selectable').removeClass('row_selected');

            // Select the current row
            $(this).addClass('row_selected');

            // Load the selected category
            ajaxLoadCategory($(this).children('td')[0].innerHTML);
        }
        else {
            $(this).removeClass('row_selected');
            fcms.formCategory.hide('fast');
        }
    });

    // Add button handler
    $('#categories_addItem').click( function (e) {
        // Remove row selection
        fcms.tableCategories.find('tr.selectable').removeClass('row_selected');

        // Load empty category
        loadCategory();

        e.preventDefault();
    });

    // Save button handler
    $('#categories_saveItem').click( function(e) {
        // Save the current category
        saveCategory();

        e.preventDefault();
    });

    // Delete button handler
    $('#categories_deleteItem').click(function(e) {
        // Find selected row
        var row = fcms.tableCategories.find('tr.selectable.row_selected')[0];

        // Remove selected row
        if (row) {
            var id = parseInt(row.children[0].innerHTML);
            if (id > -1) ajaxRemoveCategory(id, row);
        }

        e.preventDefault();
    });
}

// Initialize the age group table and bind everything
function initAgeGroupTable() {
    // Find the container
    var container = $('#div-agegroups-table');

    // Create the table structure
    var table = $('<table></table>').addClass('table table-bordered')
        .attr('id', 'table-agegroups').appendTo(container);
    var thead = $('<thead></thead>').appendTo(table);
    var tbody = $('<tbody></tbody>').appendTo(table);

    // Populate the header fields
    var headerRow = $('<tr></tr>').appendTo(thead);
    for (var a in ageGroupTableFields)
        headerRow.append('<th>' + ageGroupTableFields[a].description + '</th>');

    // Bind to age group table
    fcms.bindTable(table);
    fcms.initTable({
        "oLanguage": {
            "sEmptyTable": "Les groupes d'âges n'ont pas encore été définis pour cette classe d'inscription."
        },
        "sScrollX": "",
        "bSort": false,
        "fnCreatedRow": function(row) {
            $(row).addClass('selectable');
        }
    });
    fcms.tableAgeGroups = oTable;

    // On click event
    fcms.tableAgeGroups.on('click', 'tr.selectable', function(e) {
        if (e.target.tagName == "TR" || e.target.tagName == "TD") {
            // Select / unselect the current row
            toggleAgeGroup($(this));

            // Deselect other selected rows, if any
            fcms.tableAgeGroups.find('tr.row_edited').not($(this)).each(function() { toggleAgeGroup($(this)); });
        }
        e.stopPropagation();
    });

    // Hide search bar
    $('#table-agegroups_wrapper .row-fluid:first').hide();

    // Add "Add" and "remove" buttons
    var buttonsDiv = $('<div class="dataTables_paginate paging_bootstrap pagination table_buttons"></div>')
        .appendTo('#table-agegroups_wrapper .row-fluid:last .span6:first');
    var buttonsList = $('<ul></ul>').appendTo(buttonsDiv);

    // Add button
    $('<li><a href="#"><i class="icon-plus"></i>&nbsp;&nbsp;Ajouter</a></li>')
        .appendTo(buttonsList)
        .click(function(e) {
            // Unselect the current agegroup
            toggleAgeGroup(fcms.tableAgeGroups.$('tr.row_edited').eq(0));

            // Create new agegroup and select it
            var i = loadAgeGroup();
            toggleAgeGroup(fcms.tableAgeGroups.$('tr.selectable').eq(i));

            e.preventDefault();
        });

    // Remove button
    $('<li><a href="#"><i class="icon-minus"></i>&nbsp;&nbsp;Supprimer</a></li>')
        .appendTo(buttonsList)
        .click(function(e) {
            // Remove the selected row
            var selected = fcms.tableAgeGroups.$('tr.row_edited');
            if (selected) fcms.tableAgeGroups.fnDeleteRow(selected[0]);

            e.preventDefault();
        });
}

// Display category data in category form
function loadCategory(data) {
    // Use empty data if none is supplied
    data = data || {
        'category': {},
        'agegroups' : []
    };

    // Show the category form
    fcms.formCategory.show('fast');

    // Populate form inputs
    var re = new RegExp('category.*', 'g');
    fcms.formCategory.find('input, textarea').filter(function() { return this.id.match(re); }).each(
        function(){
            var field = $(this).attr('id').replace("category_", "");
            var value = null;
            if (field in data['category'])
                value = data['category'][field];
            if ($(this).attr('type') == "checkbox")
                $(this).prop('checked', value);
            else $(this).val(value);
        }
    );

    // Populate the age group table
    fcms.tableAgeGroups.fnClearTable()
    var oAgegroup = data['agegroups'];
    for (var i = 0; i < oAgegroup.length; i++)
        loadAgeGroup(oAgegroup[i]);
}

// Parse the form and save category data
function saveCategory() {
    // Create the save payload
    var params = fcms.formCategory.serializeObject();
    var categoryId = parseInt($('#category_id').val()) || -1;

    // Unselect any selected agegroup
    fcms.tableAgeGroups.find('tr.row_edited').each(function() { toggleAgeGroup($(this)); });

    // Add agegroups to payload
    params.agegroups = [];
    fcms.tableAgeGroups.find('tr.selectable').each(function(i) {
        params.agegroups[i] = {};
        for (var f in ageGroupTableFields) {
            var field = ageGroupTableFields[f];
            var value = $(this).children('td').eq(f).text().replace(field.suffix, "");
            params.agegroups[i][field.name] = (field.type == "number") ? (parseInt(value) || null) : value;
        }
    });

    // Send AJAX request
    ajaxSaveCategory(params, categoryId);
};

// Display an age group in the AgeGroups table
function loadAgeGroup(ageGroup) {
    ageGroup = ageGroup || {};

    aItem = [];
    for (var a in ageGroupTableFields) {
        var value = ageGroup[ageGroupTableFields[a].name];
        aItem.push(value ? value + ageGroupTableFields[a].suffix : "");
    }

    // Add to table
    return fcms.tableAgeGroups.fnAddData(aItem);
}

// Change an age group state in the AgeGroup table (static <--> editable)
function toggleAgeGroup(row) {
    var isSelected = row.hasClass('row_edited');
    row.toggleClass('row_edited');

    for (var f in ageGroupTableFields) {
        var field = ageGroupTableFields[f];
        if (!ageGroupTableFields[f].disabled) {
            // Get the editable cell
            var cell = row.children('td').eq(f);

            if (!isSelected) {
                // Get the cell text
                var cellText = cell.text() || "";
                cellText = cellText.replace(field.suffix, "");

                // Convert the cell to input
                cell.html('<input class="' + field.class + '" type="' + field.type + '" value="' + cellText + '"> ' + field.suffix);
            }
            else {
                // Set the cell text to input text
                var value = cell.children('input').val();
                cell.html(value ? value + field.suffix : "");
            }
        }
    }
}

// Load a category from the service
function ajaxLoadCategory(id) {
    $.ajax({
        url     : fcms.categoryURL + id,
        type    : 'GET',
        dataType: 'json',
        success : loadCategory
    });
}

// Remove a category from the service
function ajaxRemoveCategory(id, row) {
    $.ajax({
        url: fcms.categoryURL + id,
        type: 'DELETE',
        success: function() {
            fcms.tableCategories.fnDeleteRow(row);
            fcms.formCategory.hide('fast');
            fcms.showMessage("La catégorie a été supprimée avec succès.");
        },
        error: function(data) {
            var message = $.parseJSON(data.responseText).message;
            fcms.showMessage(message || "La catégorie n'a pas pu être supprimée.", "error");
        }
    });
}

// Save a category in the service
function ajaxSaveCategory(params, categoryId) {
    $.ajax({
        url: fcms.categoryURL + (categoryId > -1 ? categoryId : ''),
        type: (categoryId > -1 ? 'PUT' : 'POST'),
        data: $.param(params),
        success: function(data) {
            // Create the category for table input
            var aItem = [
                data['id'],
                data['name'],
                data['created_at'],
                data['updated_at']
            ];

            // Check for currently selected row
            var currentRow = fcms.tableCategories.find('tr.row_selected');
            if (currentRow.length) {
                fcms.tableCategories.fnUpdate(aItem, currentRow[0]);
            }
            else {
                var i = fcms.tableCategories.fnAddData(aItem);
                fcms.tableCategories.find('tr.selectable').eq(i).addClass("row_selected");
            }

            // Reload the current category
            ajaxLoadCategory(data['id']);

            // Notify the user
            fcms.showMessage("L'item a été sauvegardé avec succès.");
        },
        error: function() {
            fcms.showMessage("Les modifications n'ont pas pu être enregistrées.", "error");
        }
    });
}