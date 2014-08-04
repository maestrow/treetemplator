class Templator
  constructor: (@opts) ->
    @opts ?= {}
    @opts.defaultDelimeter ?= ''

  isArray = (x) ->
    typeof x is 'object' and x.constructor is Array

  apply: (data, tpl) ->
    t = if typeof tpl is 'object' then tpl._ else tpl
    if isArray data
      (@apply item, tpl for item in data).join tpl._delimeter || @opts.defaultDelimeter
    else if typeof data is 'object'
      for p of data when data.hasOwnProperty(p) and p[0] isnt '_'
        substitution = if typeof data[p] is 'string' then data[p] else @apply data[p], tpl[p]
        r = new RegExp "\\$\\{#{p}\\}", 'g'
        t = t.replace r, substitution
      t
    else # string
      t.replace /\$\{\}/g, data
      1/0

exports.Templator = Templator
exports.create = (opts) ->
  new Templator opts