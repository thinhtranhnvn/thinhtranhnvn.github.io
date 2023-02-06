"use strict"


$(document).ready((_) => {
   $(".Navigator.Toggler").on("click", (event) => {
      $(".Navigator.Toggler").toggleClass("Active")
      $(".Navigator.Folder").toggleClass("Expanded")
   })
   
   $("#search").on("keyup", (event) => {
      if (event.keyCode != 13)
         /* do nothing */ ;
      else {
         var searchInput = $("#search").val()
         var googleUrl = `https://www.google.com/search?q=${searchInput}+site%3Ahttps%3A%2F%2Fthinhtranhnvn.github.io`
         window.open(googleUrl, "_blank")
      }
   });
}) // -- document.ready


