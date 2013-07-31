function initEditRegistrations() {
    var registration_id = $('#registration_id').val();

    $("#registration-users").hide();
    changeCategory($('#registration_category_id').val());

    $.ajax({
        url: '/registrations/' + registration_id,
        type: 'get',
        success: function( data ) {

            var users = $.parseJSON(data['users']);
            var registration = $.parseJSON(data['registration']);
            var duration = registration['duration'];

            // Clean rails auto genrating stuff
            $('#performances > tbody > input').remove();
            $('#performances > tbody > tr').remove();

            $.each(registration['performances'], function(index, value){
                $('#btn-add-performance').click();

                var composer_id = value['piece']['composer']['id'];
                var composer_name = value['piece']['composer']['name'];
                var piece_title = value['piece']['title'];

                var td = $('#performances > tbody > tr').eq(index).children().first();
                td.find('input').val(composer_id);
                td.find('input').attr('data-option', composer_name);

                td.find('input').select2({
                    minimumInputLength: 2,
                    id: function(e) { return e.value},
                    ajax: {
                        url: '/autocomplete/composers',
                        dataType: 'json',
                        type: "GET",
                        data: function (term, page) {
                            return {
                                composer: term
                            };
                        },
                        results: function (data, page) {
                            return {
                                results: data
                            };
                        }
                    },
                    initSelection: function (item, callback) {
                        var id = item.val();
                        var text = item.data('option');
                        var data = { value: id, label: text };
                        callback(data);
                    },
                    formatResult: function (item) {
                        return ('<div>' + item.label + '</div>');
                    },
                    formatSelection: function (item) {
                        return (item.label);
                    },
                    escapeMarkup: function (m) {
                        return m;
                    }
                });

                td = td.next();
                td.find('input').val(piece_title);
                td = td.next();
                td.find('input').val(0);
            });

            $('#users > tbody > tr').remove();

            $.each(users, function(index, value){

                var user_id = value['user']['id'];
                var user_name = value['user']['first_name'] + ' ' + value['user']['last_name'] + ' (' + value['user']['email'] + ')';

                var td = $('#users > tbody > tr').eq(index).children().first();
                td.find('input').val(user_id);
                td.find('input').attr('data-option', user_name);

                td.find('input').select2({
                    minimumInputLength: 2,
                    id: function(e) { return e.value},
                    ajax: {
                        url: '/autocomplete/participants',
                        dataType: 'json',
                        type: "GET",
                        data: function (term, page) {
                            return {
                                user: term,
                                noUser: userList
                            };
                        },
                        results: function (data, page) {
                            return {
                                results: data
                            };
                        }
                    },
                    initSelection: function (item, callback) {
                        var id = item.val();
                        var text = item.data('option');
                        var data = { value: id, label: text };
                        callback(data);
                    },
                    formatResult: function (item) {
                        return ('<div>' + item.label + '</div>');
                    },
                    formatSelection: function (item) {
                        return (item.label);
                    },
                    escapeMarkup: function (m) {
                        return m;
                    }
                });

                td.next().find('select').val(users[index]['instrument_id']);
            });
            $('#totUsers').text($('#users .fields').length);
            $('#registration_duration').val(duration);
        }
    });
}