// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
    $('#user_birthday').datepicker({
        format: 'yyyy-mm-dd',
        viewMode: 2
    });

    var labels, mapped
    $("#input-cities").typeahead({
        source: function (query, process) {
            $.get('/cities/autocomplete', { q: query }, function (data) {
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
});