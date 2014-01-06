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
 * Dropbox - Async, ajax uploads with HTML5
 * 
 * https://gist.github.com/jhollinger/3186316
 */
function Dropbox(e,t){this.box=e;this.url=t;this.queue=[];this.num_current_uploads=0;this.picker=document.createElement("input");this.picker.setAttribute("type","file");this.box.appendChild(this.picker);this.uploads=document.createElement("div");this.box.parentNode.insertBefore(this.uploads,this.box.nextSibling);this.max_concurrent=2;this.max_size=null;this.success=null;this.error=null;this.mime_types=null;var n=this;this.box.addEventListener("dragenter",function(e){n.drag(e,true)},false);this.box.addEventListener("dragleave",function(e){n.drag(e,false)},false);this.box.addEventListener("dragover",noop,false);this.box.addEventListener("drop",function(e){n.drop(e)},false);this.picker.addEventListener("change",function(e){n.drop(e)})}function noop(e){e.stopPropagation();e.preventDefault()}Dropbox.prototype.drop=function(e){this.drag(e,false);var t=(e.dataTransfer||e.target).files;for(var n=0;n<t.length;n++)this.handle_file(t[n])};Dropbox.prototype.drag=function(e,t){noop(e);this.box.className=t?this.box.className+=" active":this.box.className.replace(/ ?active/,"")};Dropbox.prototype.handle_file=function(e){if(this.mime_types&&!e.type.match(this.mime_types)){alert(e.name+" is not an allowed file type")}else if(this.max_size&&e.size/1024/1024>this.max_size){alert(e.name+" is too large; maximum is "+this.max_size.toFixed(2)+" MB")}else{e.label=this.add_label(e);if(this.max_concurrent>-1&&this.num_current_uploads>=this.max_concurrent)this.queue.push(e);else this.process_file(e)}};Dropbox.prototype.process_file=function(e){this.num_current_uploads+=1;var t=this;var n=new FileReader;n.onload=function(n){var r=n.target.result.split(",")[1];t.upload_file(e,r)};n.readAsDataURL(e)};Dropbox.prototype.upload_file=function(e,t){var n=new FormData;n.append("filename",e.name);n.append("mimetype",e.type);n.append("data",t);n.append("size",e.size);var r=this;var i=new XMLHttpRequest;if(i.upload)i.upload.addEventListener("progress",function(t){r.handle_upload_progress(t,e.label)},false);i.open("POST",this.url);i.setRequestHeader("X-Requested-With","XMLHttpRequest");i.onreadystatechange=function(t){if(i.readyState===4){if(i.status===200){e.label.getElementsByClassName("percent")[0].innerHTML="100%";if(r.success)r.success(e,i.responseText)}else{e.label.getElementsByClassName("percent")[0].innerHTML="Error";if(r.error)r.error(e,i.statusText,i.responseText)}r.num_current_uploads-=1;if(r.queue.length>0)r.process_file(r.queue.shift());setTimeout(function(){r.uploads.removeChild(e.label)},1e3)}};i.send(n)};Dropbox.prototype.handle_upload_progress=function(e,t){if(e.lengthComputable){var n=t.getElementsByTagName("progress")[0];n.setAttribute("value",e.loaded);n.setAttribute("max",e.total);t.getElementsByClassName("percent")[0].innerHTML=(e.loaded/e.total*100).toFixed(0)+"%"}};Dropbox.prototype.add_label=function(e){var t=(e.size/1024/1024).toFixed(2);var n=document.createElement("div");n.setAttribute("class","upload-progress");n.innerHTML='<progress value="0" max="100"></progress> <span class="desc">'+e.name+' - <span class="percent">0%</span> ('+t+" MB)</span>";this.uploads.insertBefore(n,null);return n};

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

// Fetch a Textile preview and place it in preview_pane
function fetch_textile_preview(textarea, preview_pane) {
  jQuery.post('/textile-preview',
    {body: $(textarea).val()},
    function(result) { $(preview_pane).html(result) },
    'html'
  )
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

$(function() {
  // Convert data-method links into forms and submit
  $('a[data-confirm],a[data-method]').live('click', function() {
    var msg, link = $(this)
    // Make sure user wants to do this
    if ( msg = link.attr('data-confirm') ) {
      if ( !confirm(msg) ) return false
    }
    // Submit link as a form
    if ( link.attr('data-method') ) {
      handle_method(link)
      return false
    }
  })
})
