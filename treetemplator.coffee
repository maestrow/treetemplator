isObject = (x) ->
  typeof x is 'object' and x and x.constructor is Object

isArray = (x) ->
  typeof x is 'object' and x and x.constructor is Array

isObjArr = (x) ->
  isArray(x) or isObject(x)

class State
  constructor: ->
    @level = -1
    @counters = []
  up: ->
    @level++
    @counters[@level] = 0
  down: ->
    @level--
  next: ->
    @counters[@level]++

class Templator
  constructor: (@opts) ->
    @opts ?= {}
    @opts.defaultDelimeter ?= ''

  replace = (tpl, variable = '\\w+', value = '') ->
    if tpl?
      r = new RegExp "\\$\\{#{variable}\\}", 'g'
      tpl.replace r, value.toString()
    else
      value.toString()

  replaceCounters = (tpl, state) ->
    if tpl?
      i = 0
      for value in state.counters.reverse()
        i++
        r = new RegExp "\\$#{i}", 'g'
        tpl.replace r, value
      tpl

  apply: (data, tpl, state = new State()) ->
    state.up()
    result = if isArray data
      array = for item in data
        state.next()
        @apply item, tpl, state
      array.join tpl?._delimeter || @opts.defaultDelimeter
    else
      t = if typeof tpl is 'object' then tpl._ else tpl
      if isObject data
        for p of data when data.hasOwnProperty(p) and p[0] isnt '_'
          substitution = if isObjArr data[p] then @apply data[p], tpl[p], state else data[p]
          t = replace t, p, substitution
        t = replace t
      else # data as string
        t = replace t, '', data
        t = replaceCounters t, state
    state.down()
    result

exports.Templator = Templator
exports.create = (opts) ->
  new Templator opts