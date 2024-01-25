function setTheme(theme) {
  document.documentElement.setAttribute("data-theme", theme);
}

function detectColorScheme() {
  var theme = "light"; //default to light

  //local storage is used to override OS theme settings
  if (localStorage.getItem("theme")) {
    if (localStorage.getItem("theme") == "dark") {
      var theme = "dark";
    }
  } else if (!window.matchMedia) {
    //matchMedia method not supported
    return false;
  } else if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
    //OS theme setting detected as dark
    var theme = "dark";
  }
  return theme;
}

// Create a function that that formats text as you need. Here we have
// a function to localize dates:
//
//   localizeDate('sr-RS', 12, 5) == "петак, 1. јун 2012."
//   localizeDate('en-GB', 12, 5) == "Friday, 1 June 2012"
//   localizeDate('en-US', 12, 5) == "Friday, June 1, 2012"
//
// https://github.com/elm-community/js-integration-examples/blob/master/internationalization/index.html
function localizeDate(lang, year, month) {
  const dateTimeFormat = new Intl.DateTimeFormat(lang, {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  return dateTimeFormat.format(new Date(year, month));
}

// Define a Custom Element that uses this function. Here we make it
// possible to define nodes like this:
//
//     <intl-date lang="sr-RS" year="2012" month="5">
//     <intl-date lang="en-GB" year="2012" month="5">
//     <intl-date lang="en-US" year="2012" month="5">
//
// Check out src/Main.elm to see how you use this on the Elm side.
//
customElements.define(
  "intl-date",
  class extends HTMLElement {
    // things required by Custom Elements
    constructor() {
      super();
    }
    connectedCallback() {
      this.setTextContent();
    }
    attributeChangedCallback() {
      this.setTextContent();
    }
    static get observedAttributes() {
      return ["lang", "year", "month"];
    }

    // Our function to set the textContent based on attributes.
    setTextContent() {
      const lang = this.getAttribute("lang");
      const year = this.getAttribute("year");
      const month = this.getAttribute("month");
      this.textContent = localizeDate(lang, year, month);
    }
  }
);
