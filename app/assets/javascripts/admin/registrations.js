// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require datatables
//= require registrations

$(document).ready(function(){
    $('#registration_user_owner_id').typeahead();
    $("#AutresParticipants").hide();
    fcms.bindTable($('#registrations_table'));
    fcms.initTable({
        "sScrollX": "100%"
    }) ;
    $(".alert").alert();
});