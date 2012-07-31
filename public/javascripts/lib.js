// Watch for textarea[data-live-preview] and set them up to fetch textile previews
function watch_for_live_previews() {
  $(function() {
    // Live Textile preview
    $('textarea[data-live-preview]').each(function() {
      var textarea = $(this)
      var refresh = function() { fetch_textile_preview(textarea, textarea.attr('data-live-preview')) }
      // Initialize automatic refresh
      textarea.keyup(function() { refresh.only_every(1000, 'comment-preview') })
      // There's already content, so go ahead and grab a preview
      if ( textarea.val().length > 0 ) refresh()
    })
  })
}

// Fetch a Textile preview and place it in preview_pane
function fetch_textile_preview(textarea, preview_pane) {
  jQuery.post('/textile-preview',
    {body: $(textarea).val()},
    function(result) { $(preview_pane).html(result) },
    'html'
  )
}

// Execute "this" function only every n milliseconds, regardless how frequently it's called
Function.prototype.only_every = function (millisecond_delay, id) {
  var name = 'only_every_' + id
  if ( !window[name] ) {
    var function_object = this;
    window[name] = setTimeout(function() { function_object(); window[name] = null}, millisecond_delay);
  }
}

$(function() {
  // De-obfuscate email addresses
  $('.obfuscated').each(function() {
    this.innerHTML = this.innerHTML.replace(' at ', '@').replace(' dot ', '.');
    this.setAttribute('href', 'mailto:' + this.innerHTML);
  })
})
