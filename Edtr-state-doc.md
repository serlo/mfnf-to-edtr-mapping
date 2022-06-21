# Formatting and plugins in Serlo edt state

## General structure
Each element consists of a `plugin` and a `state` attribute. 
The `rows` plugin is the mother of all content. Its state contains a list of other elements.

## Plugins and their state
### Text plugin
The state contains a list of things. Possible structure of the entries of the list:

```json
{
    "type": "p",
    "children": [
        {
            "text": "Überblick über wichtige Formeln für den Zylinder",
            "strong": true
        }
    ]
}
```

```json
    {
      "type": "p",
      "children": [{ "text": "(Genaueres dazu siehe unten)." }]
    }
```

Seems like each list element has `type = p` and an attribute `children` containing another list. Its elements finally contain the content in the `text` attribute, and potentially some formatting attributes for the text.


Attributes for text formatting:
- `strong = true` for bold font
- `em = true` for emphasized?

Headings are part of text plugins. They are list elements with `type = h` and a level attribute for the heading level. Todo: Which heading levels are allowed in which content types
```json
{
    "type": "h",
    "level": 2,
    "children": [
        { "text": "Beispiele für Zylinder in der realen Welt" }
    ]
}
```

Internal links are elements with `type = a`, `href` containing the referenced serlo id (with preceeding `/`), and a childrens list with one text attribute containing the link text. 
```json
{
    "type": "a",
    "href": "/36162",
    "children": [{ "text": "Kreis" }]
}
```

Inline math is somehow wrapped into its own element of `type = math`, with `inline = true`. Todo: How do the `src` and the child text relate to each other? 
```json
{
    "type": "math",
    "src": "A_{Kreis}=\\\\mathrm r^2\\\\cdot\\\\mathrm\\\\pi",
    "inline": true,
    "children": [
        {
            "text": "A_{Kreis}=\\\\mathrm r^2\\\\cdot\\\\mathrm\\\\pi"
        }
    ]
}
```

### Table plugin
A table has a list of children of type `tr` (table row), which in turn have children of type `th` (table header) or `td` (table ???). Each of `th` and `td` has a list of children of type `p`.

### Image plugin
The image plugin has a state containing attributes `src` (with a link to the actual image), `alt` with the alt text and `maxWidth` Todo: Are there more attributes?
```json
{
    "plugin": "image",
    "state": {
        "src": "https://assets.serlo.org/legacy/57c422a2c7731_087be29dfde18b6365f31aeef2b5aced0d6e44ee.jpg",
        "alt": "Konservendose",
        "maxWidth": 200
    }
}
```

### Multimedia plugin
The multimedia plugin consists of `explanation` and `multimedia`. Additional top-level attributes are `illustrating` (boolean whether the image is only for illustration) and `width`. The explanation contains a rows plugin with some text. (Todo: Are other things allowed here?) The multimedia contains e.g. an image plugin. (Todo: Are other things allowed? Do we need others?)

### Spoiler plugin
The spoiler contains a `title` (which indeed directly contains the title, without further wrapping in text plugins) and `content`, which contains a rows plugin. Todo: Which content is allowed?
```json
        {
          "plugin": "spoiler",
          "state": {
            "title": "Übungsaufgabe",
            "content": {
              "plugin": "rows",
              "state": [{ "plugin": "injection", "state": "/60808" }]
            }
          }
        }
```

### Injection plugin
Injections inject one piece of serlo content into another. The `state` contains only the serlo id of the injected content (with preceeding `/`).

### Equations plugin
The equations plugin has two modes, for euqations and for term manipulations. Attribute `transformationTarget` is set to either `equation` or `term`, for these modes. In both modes, a list of `steps` is given. Each step contains attributes `left`, `leftSource`, `sign`, `right`, `rightSource`, `transform`, `transformSource`, `explanation`. Besides the steps, there is an attribute `firstExplanation` to be filled with a slate-container, which contains the first explanation to be shown before the first step.

`sign` is for the comparison sign and can take values `equals`, ... Todo!

The equations mode uses `left` and `leftSource` for the left-hand side, , `right` and `rightSource` for the right-hand side, `transform` and `transformSource` for the 
description of the next transformation. Each of these pairs of attributes is filled with the same latex code of formulae. Todo: Why do we have two of them, each?
`explanation` contains a slate-container plugin with an additional explanation to be shown in between the current and the next step.

In the term mode, all of `left`, `leftSource`, `transform`, `transformSource` and the content of `firstExplanation` must be empty.
