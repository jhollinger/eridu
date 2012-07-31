/*!
 * jQuery Tools v1.2.7 - The missing UI library for the Web
 * 
 * overlay/overlay.js
 * 
 * NO COPYRIGHTS OR LICENSES. DO WHAT YOU LIKE.
 * 
 * http://flowplayer.org/tools/
 * 
 */
(function(a){a.tools=a.tools||{version:"v1.2.7"},a.tools.overlay={addEffect:function(a,b,d){c[a]=[b,d]},conf:{close:null,closeOnClick:!0,closeOnEsc:!0,closeSpeed:"fast",effect:"default",fixed:!a.browser.msie||a.browser.version>6,left:"center",load:!1,mask:null,oneInstance:!0,speed:"normal",target:null,top:"10%"}};var b=[],c={};a.tools.overlay.addEffect("default",function(b,c){var d=this.getConf(),e=a(window);d.fixed||(b.top+=e.scrollTop(),b.left+=e.scrollLeft()),b.position=d.fixed?"fixed":"absolute",this.getOverlay().css(b).fadeIn(d.speed,c)},function(a){this.getOverlay().fadeOut(this.getConf().closeSpeed,a)});function d(d,e){var f=this,g=d.add(f),h=a(window),i,j,k,l=a.tools.expose&&(e.mask||e.expose),m=Math.random().toString().slice(10);l&&(typeof l=="string"&&(l={color:l}),l.closeOnClick=l.closeOnEsc=!1);var n=e.target||d.attr("rel");j=n?a(n):null||d;if(!j.length)throw"Could not find Overlay: "+n;d&&d.index(j)==-1&&d.click(function(a){f.load(a);return a.preventDefault()}),a.extend(f,{load:function(d){if(f.isOpened())return f;var i=c[e.effect];if(!i)throw"Overlay: cannot find effect : \""+e.effect+"\"";e.oneInstance&&a.each(b,function(){this.close(d)}),d=d||a.Event(),d.type="onBeforeLoad",g.trigger(d);if(d.isDefaultPrevented())return f;k=!0,l&&a(j).expose(l);var n=e.top,o=e.left,p=j.outerWidth({margin:!0}),q=j.outerHeight({margin:!0});typeof n=="string"&&(n=n=="center"?Math.max((h.height()-q)/2,0):parseInt(n,10)/100*h.height()),o=="center"&&(o=Math.max((h.width()-p)/2,0)),i[0].call(f,{top:n,left:o},function(){k&&(d.type="onLoad",g.trigger(d))}),l&&e.closeOnClick&&a.mask.getMask().one("click",f.close),e.closeOnClick&&a(document).on("click."+m,function(b){a(b.target).parents(j).length||f.close(b)}),e.closeOnEsc&&a(document).on("keydown."+m,function(a){a.keyCode==27&&f.close(a)});return f},close:function(b){if(!f.isOpened())return f;b=b||a.Event(),b.type="onBeforeClose",g.trigger(b);if(!b.isDefaultPrevented()){k=!1,c[e.effect][1].call(f,function(){b.type="onClose",g.trigger(b)}),a(document).off("click."+m+" keydown."+m),l&&a.mask.close();return f}},getOverlay:function(){return j},getTrigger:function(){return d},getClosers:function(){return i},isOpened:function(){return k},getConf:function(){return e}}),a.each("onBeforeLoad,onStart,onLoad,onBeforeClose,onClose".split(","),function(b,c){a.isFunction(e[c])&&a(f).on(c,e[c]),f[c]=function(b){b&&a(f).on(c,b);return f}}),i=j.find(e.close||".close"),!i.length&&!e.close&&(i=a("<a class=\"close\"></a>"),j.prepend(i)),i.click(function(a){f.close(a)}),e.load&&f.load()}a.fn.overlay=function(c){var e=this.data("overlay");if(e)return e;a.isFunction(c)&&(c={onBeforeLoad:c}),c=a.extend(!0,{},a.tools.overlay.conf,c),this.each(function(){e=new d(a(this),c),b.push(e),a(this).data("overlay",e)});return c.api?e:this}})(jQuery);

/*
 * Dropbox
 */
function Dropbox(a,b){this.box=a;this.url=b;this.uploads=document.createElement("div");this.box.parentNode.insertBefore(this.uploads,this.box.nextSibling);this.max_size=null;this.success=null;this.error=null;var c=this;this.box.addEventListener("dragenter",function(a){c.drag(a,true)},false);this.box.addEventListener("dragleave",function(a){c.drag(a,false)},false);this.box.addEventListener("dragover",noop,false);this.box.addEventListener("drop",function(a){c.drop(a)},false)}function noop(a){a.stopPropagation();a.preventDefault()}Dropbox.prototype.handle_file=function(a){if(this.max_size&&a.size/1024/1024>this.max_size){alert(a.name+" is too large; maximum allowed size is "+this.max_size.toFixed(2)+" MB")}else{var b=this;var c=this.add_label(a);var d=new FileReader;d.onload=function(d){var e=d.target.result.split(",")[1];b.upload_file(a,e,c)};d.readAsDataURL(a)}};Dropbox.prototype.upload_file=function(a,b,c){c.getElementsByTagName("span")[0].innerHTML="Uploading";var d=new FormData;d.append("filename",a.name);d.append("mimetype",a.type);d.append("data",b);d.append("size",a.size);var e=this;var f=new XMLHttpRequest;if(f.upload)f.upload.addEventListener("progress",function(a){e.handle_upload_progress(a,c)},false);f.open("POST",this.url);f.onreadystatechange=function(b){if(f.readyState===4){if(f.status===200){c.getElementsByTagName("span")[0].innerHTML="Completed uploading";if(e.success)e.success(a,f.responseText)}else{c.getElementsByTagName("span")[0].innerHTML="Error while uploading";if(e.error)e.error(a,f.statusText)}setTimeout(function(){e.uploads.removeChild(c)},1e3)}};f.send(d)};Dropbox.prototype.handle_upload_progress=function(a,b){if(a.lengthComputable){var c=b.getElementsByTagName("progress")[0];c.setAttribute("value",a.loaded);c.setAttribute("max",a.total)}};Dropbox.prototype.add_label=function(a){var b=(a.size/1024/1024).toFixed(2);var c=document.createElement("div");c.innerHTML="<progress></progress> <span>Processing</span> "+a.name+" ("+b+" MB)";this.uploads.insertBefore(c,null);return c};Dropbox.prototype.drag=function(a,b){noop(a);this.box.className=b?this.box.className+=" active":this.box.className.replace(/ ?active/,"")};Dropbox.prototype.drop=function(a){this.drag(a,false);var b=a.dataTransfer.files;for(var c=0;c<b.length;c++)this.handle_file(b[c])}

function bind_textile_preview(button) {
  $(button).click(function() {
    var overlay = $('#overlay')
    var preview_pane = overlay.find('.contentWrap')
    overlay.overlay()
    overlay.data('overlay').load()
    preview_pane.html('<h2>Loading...</h2>')
    fetch_textile_preview($($(this).attr('data-preview-src')), preview_pane)
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
