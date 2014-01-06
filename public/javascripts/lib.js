$(function() {
  // De-obfuscate email addresses
  $('.obfuscated').each(function() {
    this.innerHTML = this.innerHTML.replace(' at ', '@').replace(' dot ', '.');
    this.setAttribute('href', 'mailto:' + this.innerHTML);
  })
})
