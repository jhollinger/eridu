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
