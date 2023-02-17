"use strict";


// - <meta-data title="Hrdaya Sutra"
// -           keywords="hrdaya sutra, buddhist sutra, meditation, zen"
// -           description="Hrdaya Prajna Paramita, explained in natural speaking..."
// - /><!--  meta-data -->

class Metadata
extends HTMLElement {

   constructor ()
      { super () }
       
   connectedCallback () 
      { this.setMetas () }
       
   attributeChangedCallback () 
      { this.setMetas () }
       
   static get observedAttributes () 
      { return ["title", "keywords", "description"] }

   setMetas () 
      { var title = jQuery(this).attr("title")
      ; var keywords = jQuery(this).attr("keywords")
      ; var description = jQuery(this).attr("description")
        // --
      ; jQuery('head > [name="keywords"]').attr("content", keywords)
      ; jQuery('head > [name="description"]').attr("content", description)
        // --
      ; jQuery('head > [property="og:title"]').attr("content", title)
      ; jQuery('head > [property="og:description"]').attr("content", description)
      }
       
} //. Metadata

customElements.define ("meta-data", Metadata)


