// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

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
    if (category_id=="" || category_id=="Choisissez une classe") return; // please select - possibly you want something else here
    $.getJSON('/admin/categories/' + category_id, function(data) {
        nbPerfMax = data['category']['nb_perf_max'];
        nbPerfMin = data['category']['nb_perf_min'];
        if (data['agegroup']) maxDuration = data['agegroup']['max_duration'];
        else maxDuration = null;
        group = data.category.group;
        if (group) $("#AutresParticipants").show();
        else $("#AutresParticipants").hide();

        if (maxDuration == null) fcms.showMessage('Vous ne correspondez pas à une catégorie d\'âge, vous n\'avez donc pas le droit de vous inscrire dans cette classe', 3);
        $('input[type=submit]').attr('disabled', (maxDuration == null));
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
});

$(document).on('nested:fieldRemoved:performances', function(event){
    event.field.remove();
    calculateTotDuration();
});

$(document).on('nested:fieldAdded:registrations_users', function(event){
    $(event.field.find('td .user_select')[0]).typeahead();
    $('#totUsers').text($('#users .fields').length);
});

$(document).on('nested:fieldRemoved:registrations_users', function(event){
    event.field.remove();
    $('#totUsers').text($('#users .fields').length);
});

function sendInviteNewUser() {
    var lol =1;
}

function AddNewComposer() {
    var composer_name = $('#composer_name').val();
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
            fcms.showMessage('Le compositeur n\'a pas été ajouté');
        }
    });
}
