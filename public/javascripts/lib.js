window.onload = function() {
  var obfuscated = document.getElementsByClassName('obfuscated');
  for ( var i=0; i < obfuscated.length; i++  ) {
    var el = obfuscated[i];
    el.innerHTML = el.innerHTML.replace(' at ', '@').replace(' dot ', '.');
    el.setAttribute('href', 'mailto:' + el.innerHTML);
  }
};
