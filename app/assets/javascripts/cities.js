$(document).ready(function(){

    /*var jsonString = '[{"label":"Sherbrooke","value":"1"},{"label":"Magog","value":"2"},{"label":"Danville","value":"3"}]';

    var jsonObj = $.parseJSON(jsonString);
    var sourceArr = [];

    for (var i = 0; i < jsonObj.length; i++) {
        sourceArr.push(jsonObj[i].label);
    }

    $("#input-cities").typeahead({
        source: sourceArr
    });*/

    /*$("#input-cities").typeahead({
        source: function (query, process) {
            $.get('autocomplete', { q: query }, function (data) {
                process(data)
            })
        }
    });*/

    var labels
        , mapped
    $("#input-cities").typeahead({
        source: function (query, process) {
            $.get('autocomplete', { q: query }, function (data) {
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

    /*$('#input-cities').typeahead({
        source: function (query, process) {
            return $.get('autocomplete_city_name', { term: query }, function (data) {
                labels = [];

                $.each(data, function (i) {
                    labels.push(data[i].label);
                });

                return process(labels);
            });
        }
    });*/
});
