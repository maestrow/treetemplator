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
    @counters.push(0)
  down: ->
    @level--
    @counters.pop()
  next: ->
    @counters[@level]++

class Templator
  constructor: (@opts) ->
    @opts ?= {}
    @opts.defaultDelimeter ?= ''

  replace = (tpl, variable = '\\w*', value = '') ->
    if tpl?
      r = new RegExp "\\$\\{#{variable}\\}", 'g'
      tpl.replace r, value.toString()

  replaceCounters = (tpl, state) ->
    if tpl?
      j = 0
      for i in [state.counters.length-1..0]
        r = new RegExp "\\$#{j}", 'g'
        tpl = tpl.replace r, state.counters[i]
        j++
      tpl

  apply: (data, tpl, state = new State()) ->
    if isArray data
      state.up()
      array = for item in data
        state.next()
        @apply item, tpl, state
      state.down()
      array.join tpl?._delimeter || @opts.defaultDelimeter
    else
      t = if typeof tpl is 'object' then tpl._ else tpl
      if isObject data
        for p of data when data.hasOwnProperty(p) and p[0] isnt '_'
          substitution = if isObjArr data[p] then @apply data[p], tpl[p], state else data[p]
          t = replace t, p, substitution
        t = replaceCounters t, state
      else # data as string
        t = if t? then t.replace /\$\{\}/g, data else data.toString()
        t = replaceCounters t, state
      t = replace t # remove empty variables

exports.Templator = Templator
exports.create = (opts) ->
  new Templator opts