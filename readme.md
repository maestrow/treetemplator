# treetemplator

Very simple but usefull hierarchical template engine

## What is it and how to use

Suppose you have a json:
```coffee
data =
  date: new Date()
  promo:
    logo: ''
    text: ''
  offers: [
    {
      caption: 'Laguna Villa'
      address: 'On the beach'
      price: '$ 100 000'
      contact: 'Mr. Anderson'
      photos: [ '1', '2', '3' ]
    }
    {
      caption: 'House in New Orlean'
      address: 'New Orlean'
      price: '$ 50 000'
      photos: [ '1', '2' ]
    }
    {
      caption: 'Flat in New Elite Building'
      address: 'Arbat'
      price: '$ 80 000'
      contact: ''
    }
  ]
  agents: [
    { first: 'Sam', last: 'Roberts' }
    { first: 'Pete', last: 'Daniels' }
    { first: 'Gina', last: 'Richards' }
  ]
```

Define templates:
```coffee
templates =
  _: """
     Realty Dashboard. Today is ${date}.

     Todays offers:
     ${offers}

     Our Agents:
     ${agents}
     """
  offers:
    _: """
      ${price}: ${caption} at ${address}. ${photos}
    """
    _delimeter: '\n'
    photos: '[${}]'
  agents:
    _: '* ${first} ${last}'
    _delimeter: '\n'
```

Apply templates like this
```coffee
treetpl = require('../treetemplator').create()
console.log treetpl.apply data, templates
```

And get a result:
```
Realty Dashboard. Today is Mon Aug 04 2014 23:26:50 GMT+0400 (Московское время (зима)).

Todays offers:
$ 100 000: Laguna Villa at On the beach. [1][2][3]
$ 50 000: House in New Orlean at New Orlean. [1][2]
$ 80 000: Flat in New Elite Building at Arbat. 

Our Agents:
* Sam Roberts
* Pete Daniels
* Gina Richards
```

See `demo` and `tests` for more details.


## Installation 

To install and run tests:
`$ git clone https://github.com/maestrow/treetemplator`
`$ npm install`
`$ cake test` - to run tests

To install on client-side use bower and requirejs:

`$ bower install maestrow/treetemplator`
