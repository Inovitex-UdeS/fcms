$(document).ready(function(){

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

});
