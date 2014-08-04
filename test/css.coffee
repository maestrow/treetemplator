{Templator} = require '../treetemplator'

data = [
  {
    selector: '.block'
    css: [
      'background-color: red;'
      'border: 0 0 0 0;'
      'margin: 1 1 1 1;'
    ]
  }
  {
    selector: '.nav'
    css: []
  }
]

templates =
  _delimeter: '\n'
  _: """
    <div class="rule">
      <div class="selector">
        <input type="checkbox"> <label>${selector}</label>
      </div>
      <div class="cssText">
        ${css}
      </div>
    </div>
  """
  css:
    _: "${}<br/>"
    _delimeter: '\n'

console.log new Templator().apply data, templates