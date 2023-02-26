"use strict";


const activeSearchBox = (_) => {

   jQuery("#search").keypress((event) => {
      var enterPressed = (event.key == "Enter") || (event.keyCode == 13)
      //.
      if (! enterPressed)
         /* do nothing */ ;
      else {
         var searchString = encodeURIComponent( jQuery("#search").val() )
         var searchPostfix = encodeURIComponent("site:https://thinhtranhnvn.github.io")
         var googleUrl = `https://www.google.com/search?q=${searchString}+${searchPostfix}`
         var newTab = window.open(googleUrl, "_blank")
      }
   }) //. #search
   
} //. activeSearchBox


window.setTimeout(activeSearchBox, 1_000)


