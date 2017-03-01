/*! loadJS: load a JS file asynchronously. [c]2014 @scottjehl, Filament Group, Inc. (Based on http://goo.gl/REQGQ by Paul Irish). Licensed MIT */
(function( w ){
  var loadJS = function( src, cb ){
    "use strict";
    var ref = w.document.getElementsByTagName( "script" )[ 0 ];
    var script = w.document.createElement( "script" );
    script.src = src;
    script.async = true;
    ref.parentNode.insertBefore( script, ref );
    if (cb && typeof(cb) === "function") {
      script.onload = cb;
    }
    return script;
  };
  // commonjs
  if( typeof module !== "undefined" ){
    module.exports = loadJS;
  }
  else {
    w.loadJS = loadJS;
  }
}( typeof global !== "undefined" ? global : this ));


/* The addition of new Date().getTime() to the URL is to prevent too-aggressive caching of AJAX by Safari */
loadJS("http://www.thisisshowroom.com/assets/shopwidget-5846288364779cfd9b9db6142a085d17f6a78c20f28162c365c668b32c6010c3.js?user=0514312981&cache=" + new Date().getTime());
