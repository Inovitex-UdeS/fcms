// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables
//= require edit_registration

var nbPerfMax = 0;
var nbPerfMin = 0;
var maxDuration = 0;
var group = false;
var curDuration = 0;
var nbPersMax = 12;
var userList = [];

// Autocomplete
$(document).ready(function(){
    $('#registration_school_id').typeahead();

    $('#new_registration').on('ajax:success', function(evt, data, status, xhr) {
        $('fcms-message').remove();
        fcms.showMessage('L\'enregistrement au festival a été complété avec succès!');
        clearForm();
    });

    $('#new_registration').on('ajax:error', function(event, xhr, status) {
        $('fcms-message').remove();
        fcms.showMessage(xhr.responseText, 3);
    });

    $('#registration_user_teacher_id').select2({
        minimumInputLength: 2,
        id: function(e) { return e.value},
        ajax: {
            url: '/autocomplete/teachers',
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

    $('#registration_user_accompanist_id').select2({
        allowClear: true,
        minimumInputLength: 2,
        id: function(e) { return e.value},
        ajax: {
            url: '/autocomplete/accompanists',
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

    userList = [$('#registration_user_owner_id').val()];

    $('form').submit(function(e) {
        return validateRegForm();
    });
});

function changeCategory(category_id) {
    if (category_id=="" || category_id=="Classe") { // please select - possibly you want something else here
        $("#category-description").hide('fast').text("");
        $("#registration-pieces").hide('fast');
        return;
    }
    $.getJSON('/categories/' + category_id, function(data) {
        nbPerfMax = data['category']['nb_perf_max'];
        nbPerfMin = data['category']['nb_perf_min'];
        $("#category-description").hide('fast', function() {
            $(this).html(data['category']['description']);
        }).show('fast');

        if (data['agegroup']) maxDuration = data['agegroup']['max_duration'];
        else maxDuration = null;

        group = data.category.group;
        if (group) $("#registration-users").show();
        else $("#registration-users").hide();

        accomp = data.category.accompanist;
        if (accomp) $("#registration-accompanist").show();
        else $("#registration-accompanist").hide();

        $("#registration-pieces").show('fast');

        if (maxDuration == null) fcms.showMessage('Vous ne correspondez pas à une catégorie d\'âge, vous n\'avez donc pas le droit de vous inscrire dans cette classe', 3);
        $('input[type=submit]').attr('disabled', (maxDuration == null));

        if (maxDuration != null) $('.unit_duration').attr('max', maxDuration);
        else  $('.unit_duration').attr('max', 0);
    });
}

// Calculate all the durations in the table
function calculateTotDuration() {
    curDuration = 0;
    $('input[name$="unit_duration"]').each(function() {
        if($(this).val()){
            curDuration += parseFloat($(this).val());
        }
    });
    $('#registration_duration').val(curDuration);
    if(curDuration > maxDuration) fcms.showMessage('Vous avez dépassé la limite de temps permise pour cette catégorie.', 2);
    $('input[type=submit]').attr('disabled', curDuration > maxDuration);
}

// TRIGGERS SECTION
$(document).on('nested:fieldAdded:performances', function(event){
    $(event.field.find('td .composer_select')[0]).select2({
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

    $(event.field.find('td > input')[0]).on('change', function(e) {

        $(e.target).parent().next().find('input').attr('data-composer', e.val)

    });

    $(event.field.find('td:nth-child(2) > input')[0]).typeahead({
        source: function (query, process) {


            $.get('/autocomplete/pieces', { query: query, composer: this.$element.attr('data-composer') }, function (data) {
                labels = []

                $.each(data, function (i, item) {
                    labels.push(item.label)
                })

                process(labels)
            })
        }
    });

    if (maxDuration != null) $(event.field.children().find('.unit_duration')).attr('max', maxDuration);
    else  $(event.field.children().find('.unit_duration')).attr('max', 0);
    $(event.field).hide().fadeIn("slow");
});

$(document).on('nested:fieldRemoved:performances', function(event){
    event.field.remove();
    calculateTotDuration();
});

$(document).on('nested:fieldAdded:registrations_users', function(event){
    $(event.field.find('td .user_select')[0]).select2({
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

    $(event.field.find('td > input')[0]).on('change', function(e) {
        userList = [$('#registration_user_owner_id').val()];
        $.each($('#users input.user_select'), function(index, value){
            userList.push($(value).val());
        })
    });

    $('#totUsers').text($('#users .fields').length);
    $(event.field).hide().fadeIn("slow");
});

$(document).on('nested:fieldRemoved:registrations_users', function(event){
    event.field.remove();
    $('#totUsers').text($('#users .fields').length);
    userList = [$('#registration_user_owner_id').val()];
    $.each($('#users input.user_select'), function(index, value){
        userList.push($(value).val());
    })
});

function inviteNewUser() {
    $.ajax({
        url     : '/users/invitation',
        type    : 'post',
        dataType: 'json',
        data    : $('#new_user').serialize(),
        success : function( data ) {
            $('#inviteNewUser').modal('hide');
            $("#new_user")[0].reset();
            fcms.showMessage('L\'utilisateur a été invité avec succès');
        },
        error   : function( xhr, err ) {
            $('#inviteNewUser').modal('hide');
            $("#new_user")[0].reset();
            fcms.showMessage('L\'utilisateur n\'a pas été invité', 3);
        }
    });
}

function AddNewComposer() {
    $.ajax({
        url     : '/composers',
        type    : 'post',
        dataType: 'json',
        data    : $('#new_composer').serialize(),
        success : function( data ) {
            $('#addNewComposer').modal('hide');
            $("#new_composer")[0].reset();
            fcms.showMessage('Le compositeur a été ajouté avec succès');
        },
        error   : function( xhr, err ) {
            $('#addNewComposer').modal('hide');
            $("#new_composer")[0].reset();
            fcms.showMessage('Le compositeur n\'a pas été ajouté', 3);
        }
    });
}

function clearForm() {
    $('#performances > tbody > tr').remove();
    $('#users > tbody > tr').remove();

    $('#registration_user_teacher_id').select2('data', null);
    $('#registration_user_accompanist_id').select2('data', null);

    calculateTotDuration();
    $('#totUsers').text($('#users .fields').length);
    $('#category-description').remove();
    $('form')[0].reset();
}


function validateRegForm() {
    var errorString = '';

    if ( !$('#registration_user_teacher_id').val() ) {
        errorString += "<li>Un professeur doit être sélectionné</li>"
    }

    if ( !$('#registration_category_id').val() ) {
        errorString += "<li>Une classe d'inscription doit être sélectionnée</li>"
    }

    if ( !$('#registration_instrument_ids').val() ) {
        errorString += "<li>Un instrument doit être sélectionné</li>"
    }

    if ( !($('#performances > tbody > tr').length > 0) ) {
        errorString += "<li>L'inscription doit contenir au moins une oeuvre performée</li>"
    }

    $.each($('input.composer_select'), function(index, value) {
        if ( !$(value).val() ) {
            errorString += "<li>Une ou plusieurs oeuvres performées n'ont pas de compositeur</li>"
            return false;
        }
    });

    $.each($('input.piece_select'), function(index, value) {
        if ( !$(value).val() ) {
            errorString += "<li>Une ou plusieurs oeuvres performées n'ont pas de titre</li>"
            return false;
        }
    });

    $.each($('input.unit_duration'), function(index, value) {
        if ( !$(value).val() ) {
            errorString += "<li>Une ou plusieurs oeuvres performées ont une durée nulle</li>"
            return false;
        }
    });

    if ( !($('#registration_duration').val() > 0) ) {
        errorString += "<li>L'inscription doit avoir une durée totale plus grande que 0</li>"
    }

    if ( ($('#users > tbody > tr').length > 0) ) {

        $.each($('input.user_select'), function(index, value) {
            if ( !$(value).val() ) {
                errorString += "<li>Un ou plusieurs participants supplémentaires n'ont pas été sélectionnés</li>"
                return false;
            }
        });

        $.each($('input.instrument_select'), function(index, value) {
            if ( !$(value).val() ) {
                errorString += "<li>Un ou plusieurs participants supplémentaires n'ont pas d'instrument</li>"
                return false;
            }
        });
    }

    if ( errorString )  {
        errorString = "<h4>La ou les raisons suivantes empêchent l'enregistrement de l'inscription:</h4> <ul>" + errorString + "</ul>";

        var curmsg = $('<div></div>').addClass('fcms-message alert alert-error')
            .html(errorString).appendTo('body');

        curmsg.css({ 'marginLeft': -curmsg.width() / 2, 'left': '50%' })
            .prepend('<button type="button" class="close" data-dismiss="alert">&times;</button>');

        return false;
    }

    return true;
}