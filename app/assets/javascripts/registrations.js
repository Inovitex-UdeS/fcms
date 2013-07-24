// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables

var nbPerfMax = 0;
var nbPerfMin = 0;
var maxDuration = 0;
var group = false;
var curDuration = 0;
var nbPersMax = 12;

// Autocomplete
$(document).ready(function(){
    $('#registration_user_teacher_id').typeahead();
    $('#registration_school_id').typeahead();

    $('#new_registration').on('ajax:success', function(evt, data, status, xhr) {
        fcms.showMessage('L\'enregistrement au festival a été complété avec succès!');
        $('#new_registration')[0].reset();
    });

    $('#new_registration').on('ajax:error', function(event, xhr, status) {
        fcms.showMessage(xhr.responseText, 3);
    });
});

function changeCategory(category_id) {
    if (category_id=="" || category_id=="Classe") return; // please select - possibly you want something else here
    $.getJSON('/categories/' + category_id, function(data) {
        nbPerfMax = data['category']['nb_perf_max'];
        nbPerfMin = data['category']['nb_perf_min'];
        $("#category-description").text(data['category']['description'])

        if (data['agegroup']) maxDuration = data['agegroup']['max_duration'];
        else maxDuration = null;
        group = data.category.group;
        if (group) $("#AutresParticipants").show();
        else $("#AutresParticipants").hide();

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
                    composer: term
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


            $.get('/autocomplete/pieces', { q: query, c: this.$element.attr('data-composer') }, function (data) {
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
                    user: term
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
    $('#totUsers').text($('#users .fields').length);
    $(event.field).hide().fadeIn("slow");
});

$(document).on('nested:fieldRemoved:registrations_users', function(event){
    event.field.remove();
    $('#totUsers').text($('#users .fields').length);
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

function ResetSelect2() {
    $.each($('#performances .fields'), function(index, value) {
        $(value).remove();
    });

    $.each($('#users .fields'), function(index, value) {
        $(value).remove();
    });
    $('#totUsers').text($('#users .fields').length);
}
