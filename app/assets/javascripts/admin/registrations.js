// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require registrations

$(document).ready(function(){

    $('#formSave').click(function(e) {
        if(!validateRegForm()) {
            e.stopImmediatePropagation();
            return false;
        }
    });

    var tsDTOptions = {
        "aaSorting": [ [1,'asc'], [2,'asc'], [4,'asc'] ],
        "bInfo": false,
        "bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": $('#all-registrations-table').data('source'),
        "fnDrawCallback": function( oSettings ) {
            // Add a click handler to the rows (selectable rows)
            $.each(oTable.fnGetNodes(), function() {
                $(this).single_double_click(fcms.fnSelectableRows, fcms.fnEditableRows);
            });
        }
    };

    $("#registration-users").hide();
    fcms.bindTable($('#all-registrations-table'));
    fcms.initTable(tsDTOptions);
    fcms.bindForm($('form'), 4);
    $('#formModal').bigmodal('hide');

    $('#registration_user_owner_id').select2({
        minimumInputLength: 2,
        id: function(e) { return e.value},
        ajax: {
            url: '/autocomplete/participants',
            dataType: 'json',
            type: "GET",
            data: function (term, page) {
                return {
                    query: term
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

    $('#formModal').on('hide', function () {
        $('.fcms-message').remove();
    });
});

fcms.fnClearForm = function () {
    $('form')[0].reset();
    $('#registration_id').val(null);
    $('#registration_user_owner_id').select2('data', null);
    $('#registration_user_teacher_id').select2('data', null);
    $('#registration_user_accompanist_id').select2('data', null);
    $('#performances > tbody > tr').remove();
    $('#users > tbody > tr').remove();
    $('#category-description').remove();
};

fcms.fnSuccessAddItem = function( data ) {
    $('#formModal').modal('hide');

    var registration = $.parseJSON(data['registration']);
    var category = data['category'];
    var users = data['users'];
    var instruments = data['instruments'];
    var edition = data['edition'];
    var teacher = $.parseJSON(data['teacher']);
    var pieces = data['pieces'];
    var composers = data['composers'];

    var aItem = new Array();

    aItem.push(registration['id']);
    aItem.push(category);
    aItem.push(instruments);
    aItem.push(users);
    aItem.push(registration['age_max']);
    aItem.push(pieces);
    aItem.push(composers);
    aItem.push(teacher['last_name'] + ', ' + teacher['first_name']);
    aItem.push(registration['duration'] + ' min.');
    aItem.push(edition);
    aItem.push(fcms.fnFormatDate(registration['created_at']));
    aItem.push(fcms.fnFormatDate(registration['updated_at']));

    var iRow = oTable.fnAddData(aItem);

    $(oTable.fnGetNodes(iRow)).single_double_click(fcms.fnSelectableRows, fcms.fnEditableRows);

    fcms.fnClearForm();

    fcms.showMessage('L\'item a été ajouté avec succès.');

    oTable.$('tr.row_selected').removeClass('row_selected');
};

fcms.fnSuccessUpdateData = function( data ) {
    $('#formModal').modal('hide');

    var registration = $.parseJSON(data['registration']);
    var category = data['category'];
    var users = data['users'];
    var instruments = data['instruments'];
    var edition = data['edition'];
    var teacher = $.parseJSON(data['teacher']);
    var pieces = data['pieces'];
    var composers = data['composers'];

    var aItem = new Array();

    aItem.push(registration['id']);
    aItem.push(category);
    aItem.push(instruments);
    aItem.push(users);
    aItem.push(registration['age_max']);
    aItem.push(pieces);
    aItem.push(composers);
    aItem.push(teacher['last_name'] + ', ' + teacher['first_name']);
    aItem.push(registration['duration'] + ' min.');
    aItem.push(edition);
    aItem.push(fcms.fnFormatDate(registration['created_at']));
    aItem.push(fcms.fnFormatDate(registration['updated_at']));

    oTable.fnUpdate(aItem, fcms.fnGetSelected(oTable)[0]);

    fcms.fnClearForm();
    oTable.$('tr.row_selected').removeClass('row_selected');

    fcms.showMessage('L\'item a été modifié avec succès.');
};

fcms.fnSuccessGetData = function( data ) {
    fcms.fnClearForm();

    var owner = $.parseJSON(data['owner']);
    var teacher = $.parseJSON(data['teacher']);
    var accompanist = $.parseJSON(data['accompanist']);
    var users = $.parseJSON(data['users']);
    var registration = $.parseJSON(data['registration']);
    var instrument = $.parseJSON(data['instrument']);
    var duration = registration['duration'];

    $("#registration-users").hide();

    $('#registration_id').val(registration['id']);

    if (owner) $('#registration_user_owner_id').select2('data', {value: owner['id'], label: owner['first_name'] + ' ' + owner['last_name'] + ' (' + owner['email'] +')'});
    if (teacher) $('#registration_user_teacher_id').select2('data',  {value: teacher['id'], label: teacher['first_name'] + ' ' + teacher['last_name'] + ' (' + teacher['email'] +')'});
    if (accompanist) $('#registration_user_accompanist_id').select2('data', {value: accompanist['id'], label: accompanist['first_name'] + ' ' + accompanist['last_name'] + ' (' + accompanist['email'] + ')'});

    $('#registration_category_id').val(registration['category_id']);
    $('#registration_instrument_ids').val(instrument['id']);

    changeCategory($('#registration_category_id').val());

    $.each(registration['performances'], function(index, perf){
        $('#btn-add-performance').click();

        var composer_id = perf['piece']['composer']['id'];
        var composer_name = perf['piece']['composer']['name'];
        var piece_title = perf['piece']['title'];

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
                        query: term
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

    $('#users > tbody > tr:first').remove();

    $.each(users, function(index, user){
        $('#btn-add-users').click();

        var user_id = user['user']['id'];
        var user_name = user['user']['first_name'] + ' ' + user['user']['last_name'] + ' (' + user['user']['email'] + ')';

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
                        query: term,
                        users: userList
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

       td.next().find('select').val(user['instrument_id']);

    });

    $('#totUsers').text($('#users .fields').length);
    $('#registration_duration').val(duration);
    $('#formModal').modal('show');
};