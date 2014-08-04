assert = require 'assert'
treetpl = require('../treetemplator').create()

check = (data, tpl, expected) ->
  result = treetpl.apply data, tpl
  assert.equal result, expected

describe 'Simple data: string, array, object. Ex: "ab", ["a", "b"], {a: "aaa", b: "bbb"}', ->
  describe 'String', ->
    data = 'ab'
    it 'undefined template', ->
      check data, undefined, 'ab'
    it 'template as string', ->
      check data, '<${}>', '<ab>'
    it 'template in special "_"-property', ->
      check data, { _: '<${}>' }, '<ab>'
    it 'delimeter', ->
      check data, { _delimeter: ', ' }, 'ab'
    it 'delimeter and template', ->
      check data, { _: '<${}>', _delimeter: ', ' }, '<ab>'
    it 'all variables should be filled', ->
      check data, '${} ${} ${}', 'ab ab ab'
    it 'empty variables in templates should be removed', ->
      check data, '<${}> ${asd}', '<ab> '

  describe 'Array', ->
    data = ['a', 'b']
    it 'undefined template', ->
      check data, undefined, 'ab'
    it 'template as string', ->
      check data, ' <${}> ', ' <a>  <b> '
    it 'template in special "_"-property', ->
      check data, { _: ' <${}> ' }, ' <a>  <b> '
    it 'delimeter', ->
      check data, { _delimeter: ', ' }, 'a, b'
    it 'delimeter and template', ->
      check data, { _: '<${}>', _delimeter: ', ' }, '<a>, <b>'
    it 'all variables should be filled', ->
      check data, '${} ${} ${}', 'a a ab b b'
    it 'empty variables in templates should be removed', ->
      check data, '<${}> ${asd}', '<a> <b> '

  describe 'Object', ->
    data = { a: 'aaa', b: 'bbb' }
    it 'undefined template', ->
      check data, undefined, undefined
    it 'template as string', ->
      check data, '${a} + ${b}', 'aaa + bbb'
    it 'template in special "_"-property', ->
      check data, { _: '${a} + ${b}' }, 'aaa + bbb'
    it 'all variables should be filled', ->
      check data, '${a} ${a} ${a}', 'aaa aaa aaa'
    it 'empty variables in templates should be removed', ->
      check data, '<${b}> ${asd} ${}', '<bbb>  '



describe 'Hierarchies - most interesting cases', ->

  it 'Array of objects', ->
    data = [ {a:'qwe'}, {a:'asd'} ]
    tpl =
      _: '${a}'
      _delimeter: ', '
    check data, tpl, 'qwe, asd'

  it 'Object - Array - Object - Array - Object - Value', ->
    data =
      aaa: [
        {
          bbb: [
            { ccc: '111' }
          ]
        }
        {
          bbb: [
            { ccc: '121' }
            { ccc: '122' }
          ]
        }
      ]

    tpl =
      _: 'a:${aaa}'
      aaa:
        _: 'b:${bbb}',
        _delimeter: ';  '
        bbb:
          _: 'c:${ccc}'
          _delimeter: ','

    check data, tpl, 'a:b:c:111;  b:c:121,c:122'



describe 'Uncommon cases', ->

  class Person
    constructor: (@name, @age) ->
    toString: -> "name: #{@name}, age: #{@age}"

  it 'Complex objects without templates', ->
    data = ['aaa', { a: 1 }, new Person('Mike', 26)]
    check data, { _: '${}', _delimeter: '; ' }, 'aaa; ; name: Mike, age: 26'

  it 'Nested arrays', ->
    data = ['aaa', ['a', 'b', ['x', 'y']]]
    check data, { _: '${}', _delimeter: '; ' }, 'aaa; a; b; x; y'