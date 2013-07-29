
//= require datatables

$(document).ready(function() {
    $('form').on('ajax:success', function(evt, data, status, xhr) {
        fcms.showMessage('L\'item a été ajouté avec succès!');
    });

    $('form').on('ajax:error', function(event, xhr, status) {
        fcms.showMessage(xhr.responseText, 3);
    });
});