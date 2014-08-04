treetpl = require('../treetemplator').create()

class Person
  constructor: (@name, @age) ->
  toString: ->
    "Name: #{@name}, Age: #{@age}"

data =
  "null": null
  undef: undefined
  string: 'some text'

  date: new Date()
  customObject: new Person('Jack', 32),

  array: ['aaa', 'bbb', 'ccc']
  emptyArray: []

  templatedArray: [1, 'bbb', new Person('Mike', 23)]

  complexArray: [
    { args: [1,2,3], sum: '6' }
    { args: [-1,1,2], sum: '2' }
    { args: [-1,2,7], sum: '8' }
  ]

  list: [
    { name: 'abc', list: ['a','b','c'] }
    { name: 'def', list: ['d','e','f'] }
    { name: 'ghi', list: ['g','h','i'] }
  ]

templates =
  _: """
     undefined: ${undef}
     undefined2: ${undef2}
     null: ${null}
     string: ${string}

     date: ${date}
     customObject: ${customObject}

     array:
       ${array}
     emptyArray: ${emptyArray}

     templatedArray: ${templatedArray}

     complexArray:
       ${complexArray}

     ${list}
     """,
  templatedArray: ' =[${}]= '
  complexArray:
    _: '[${args} = ${sum}]'
    _delimeter: '\n'
    args: { _delimeter: '+' }
  list:
    _: '$0. ${name}\n${list}'
    _delimeter: '\n'
    list:
      _: '$1.$0. ${}'
      _delimeter: '\n'


console.log treetpl.apply data, templates
