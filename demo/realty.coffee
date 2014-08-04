treetpl = require('../treetemplator').create()

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

console.log treetpl.apply data, templates