$(function() {
  // Convert data-method links into forms and submit
  $('a[data-confirm], a[data-method], a[data-remote]').live('click', function() {
    var link = $(this)
    // Make sure user wants to do this
    if ( !allow_action(link) ) return false
    // Submit remote link
    if ( link.attr('data-remote') ) {
      handle_remote(link)
      return false
    // Submit link as a form
    } else if ( link.attr('data-method') ) {
      handle_method(link)
      return false
    }
  })
})

function bind_textile_preview(button, textarea) {
  $(button).click(function() {
    var overlay = $('#overlay')
    var preview_pane = overlay.find('.contentWrap')
    overlay.overlay({mask: {color: '#000', opacity: 0.4}})
    overlay.data('overlay').load()
    preview_pane.html('<h2>Loading...</h2>')
    fetch_textile_preview(textarea, preview_pane)
  })
}

// Ask user to confirm link
function allow_action(link) {
  var msg = link.attr('data-confirm')
  return !msg || (confirm(msg))
}

// Convert a link to a form and submit it
function handle_method(link) {
  var url = link.attr('href'),
      method = link.attr('data-method') || 'GET',
      form = $('<form method="post" action="' + url + '"></form>'),
      metadata_input = '<input name="_method" value="' + method + '" type="hidden" />'
  form.hide().append(metadata_input).appendTo('body')
  form.submit()
}

// Submits remote links with ajax
function handle_remote(element) {
  var dataType = element.attr('data-type') || ($.ajaxSettings && $.ajaxSettings.dataType);
  var method = element.attr('data-method') || 'GET';
  var url = element.attr('href');
  var data = null;

  $.ajax({
    url: url, type: method, data: data, dataType: dataType,
    // stopping the "ajax:beforeSend" event will cancel the ajax request
    beforeSend: function(xhr, settings) {
      if (settings.dataType === undefined) {
        xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
      }
      return fire(element, 'ajax:beforeSend', [xhr, settings]);
    },
    success: function(data, status, xhr) {
      element.trigger('ajax:success', [data, status, xhr]);
    },
    complete: function(xhr, status) {
      element.trigger('ajax:complete', [xhr, status]);
    },
    error: function(xhr, status, error) {
      element.trigger('ajax:error', [xhr, status, error]);
    }
  });
}

// Triggers an event on an element and returns the event result
function fire(obj, name, data) {
  var event = new $.Event(name);
  obj.trigger(event, data);
  return event.result !== false;
}
