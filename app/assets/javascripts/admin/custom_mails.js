$(document).ready(function() {
    $('form').on('ajax:success', function(evt, data, status, xhr) {
        $('.fcms-message').remove();
        var curmsg = $('<div></div>').addClass('fcms-message alert alert-success')
            .html(data['message']).appendTo('body');

        curmsg.css({ 'marginLeft': -curmsg.width() / 2, 'left': '50%' })
            .prepend('<button type="button" class="close" data-dismiss="alert">&times;</button>');
        $('form')[0].reset();
    });

    $('form').on('ajax:error', function(event, xhr, status) {
        var curmsg = $('<div></div>').addClass('fcms-message alert alert-error')
            .html($.parseJSON(xhr.responseText)['message']).appendTo('body');

        curmsg.css({ 'marginLeft': -curmsg.width() / 2, 'left': '50%' })
            .prepend('<button type="button" class="close" data-dismiss="alert">&times;</button>');

    });

    $('form').submit(function () {
        var curmsg = $('<div></div>').addClass('fcms-message alert alert-info')
            .html("Le message est en train de se faire envoyer, celà peut prendre quelques minutes...").appendTo('body');

        curmsg.css({ 'marginLeft': -curmsg.width() / 2, 'left': '50%' })
            .prepend('<button type="button" class="close" data-dismiss="alert">&times;</button>');
        return true;
    });
});