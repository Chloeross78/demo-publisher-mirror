(function(global) {
  function getSelectionText() {
      var text = "";
      if (window.getSelection) {
          text = window.getSelection().toString();
      } else if (document.selection && document.selection.type != "Control") {
          text = document.selection.createRange().text;
      }
      return text;
  }

  // init object with correct fields
  // show blank record in corner
  // loop
  //   get selection text
  //   show buttons for each field next to text
  //   on click fill in that field

  setInterval(function(){ console.log(getSelectionText()); }, 500);
})(window);
