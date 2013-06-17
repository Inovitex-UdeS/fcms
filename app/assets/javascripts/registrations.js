// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var nbPerfMax = 0;
var nbPerfMin = 0;
var maxDuration = 0;
var curDuration = 0;
var nbPersMax = 12;

function changeCategory(category_id) {
    if (category_id=="" || category_id=="Choisissez une classe") return; // please select - possibly you want something else here
    $.getJSON('/categories?id=' + category_id, function(data) {
        nbPerfMax = data.category.nb_perf_max;
        nbPerfMin = data.category.nb_perf_min;
        maxDuration = data.max_duration.max_duration;
    });
}

// Calculate all the durations in the table (TODO: Trigger alter when curDuration > maxDuration)
function calculateTotDuration() {
    curDuration = 0;
    $('.duration').each(function() {
        if($(this).val()){
            curDuration += parseFloat($(this).val());
        }
    });
    $('#registration_duration').val(curDuration);
    if(curDuration > maxDuration) alert("Trop de temps!")
}

// Overload insertfields function to add column directly before the last row
window.NestedFormEvents.prototype.insertFields = function(content, assoc, link) {
    var $tr = $('#' + assoc + ' tr:last');
    return $(content).insertBefore($tr);
}
$(document).on('nested:fieldAdded', function(event){
    applyautocomplete();
})

$(document).on('nested:fieldAdded:users', function(event){
    // this field was just inserted into your form
    $('#totUsers').text($('#users .fields').length);
})

$(document).on('nested:fieldRemoved', function(event){
    // this field was just removed from your form
    $('#totUsers').text($('#users .fields').length-1);
})

// Delete rows (not only hide them)
$(document).on('nested:fieldRemoved', function(event){
    // this field was just inserted into your form
    var field = event.field;
    field.remove();
    calculateTotDuration();
})

// Autocomplete
$(document).ready(function(){
    applyautocomplete();
});

function applyautocomplete() {

    var labels, mapped
    $(".input-schools").typeahead({
        source: function (query, process) {
            $.get('/autocomplete/schools', { q: query }, function (data) {
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
    $(".input-pieces.input-pieces-compos").typeahead({
        source: function (query, process) {
            $.get('/autocomplete/pieces', { q: query }, function (data) {
                labels = []
                valuesMap = {}
                titleMap = {}
                composMap = {}

                $.each(data, function (i, item) {
                    valuesMap[item.label] = item.value
                    titleMap[item.label] = item.title
                    composMap[item.label] = item.composer
                    labels.push(item.label)
                })

                process(labels)
            })
        },
        updater: function (item) {
            // Set Piece ID
            this.$element.parent().next().next().val(valuesMap[item]);

            // Set piece title
            this.$element.parent().parent().find(".input-pieces-title").val(titleMap[item]);

            // This will set the piece composer name
            return composMap[item];
        }
    });


    $(".input-pieces.input-pieces-title").typeahead({
        source: function (query, process) {
            $.get('/autocomplete/pieces', { q: query }, function (data) {
                labels = []
                valuesMap = {}
                titleMap = {}
                composMap = {}

                $.each(data, function (i, item) {
                    valuesMap[item.label] = item.value
                    titleMap[item.label] = item.title
                    composMap[item.label] = item.composer
                    labels.push(item.label)
                })

                process(labels)
            })
        },
        updater: function (item) {
            // Set Piece ID
            this.$element.parent().next().next().val(valuesMap[item]);

            // Set piece composer name
            this.$element.parent().parent().find(".input-pieces-compos").val(composMap[item]);

            // This will set the piece composer name
            return titleMap[item];
        }
    });
}