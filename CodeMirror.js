var exampleJs = `customElements.define(
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
        return ["lang", "year", "month", "day"];
      }

      // Our function to set the textContent based on attributes.
      setTextContent() {
        const lang = this.getAttribute("lang");
        const year = this.getAttribute("year");
        const month = this.getAttribute("month");
        const day = this.getAttribute("day");
        this.textContent = localizeDate(lang, year, month, day);
      }
    }
  );`;

customElements.define(
  "code-editor",
  class extends HTMLElement {
    constructor() {
      super();
      this._editorValue = exampleJs;
    }

    get editorValue() {
      return this._editorValue;
    }

    set editorValue(string) {
      if (this._editorValue === string) return;
      this._editorValue = string;
      if (!this._editor) return;
      this._editor.setValue(string);
    }

    connectedCallback() {
      this._editor = CodeMirror(this, {
        indentUnit: 4,
        mode: "javascript",
        lineNumbers: true,
        value: this._editorValue,
      });

      this._editor.on("changes", () => {
        this._editorValue = this._editor.getValue;
        this.dispatchEvent(new CustomEvent("editorChanged"));
      });
    }
  }
);
