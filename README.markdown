# Lohnsteuer

[![Gem Version](https://badge.fury.io/rb/lohnsteuer.svg)](https://badge.fury.io/rb/lohnsteuer)
[![Build Status](https://travis-ci.org/JanAhrens/lohnsteuer-ruby.svg)](https://travis-ci.org/JanAhrens/lohnsteuer-ruby)

This is a Ruby implementation of the German income tax calculation
algorithm.

The algorithm gets updated by the
[Federal Ministry of Finance (Bundesministerium der Finanzen)](http://www.bundesfinanzministerium.de/Web/EN/Home/home.html)
yearly (sometimes multiple times a year). Currently following
versions are supported:

* [LST1215](lib/lohnsteuer/lst1215.rb) (for December 2015)
* [LST2016](lib/lohnsteuer/lst2016.rb) (for 2016)

## Usage

```ruby
require 'lohnsteuer'

Lohnsteuer.calculate(2016, 40000, tax_class: 1)
```

## Contributing

The algorithms where implemented by translating the program flowcharts
published by the [Bundesministerium der Finanzen](https://www.bmf-steuerrechner.de/)
into Ruby code.
The algorithms weren't modified on purpose to enable updates and verification.

**State of the project**: Initial release.

If you like to contribute, please send a pull-request. Make sure that
all tests pass and you add additional ones.

## Related projects

* [vschoettke/node-lohnsteuer](https://github.com/vschoettke/lohnsteuer): Node.js implementation
* [MarcelLehmann/Lohnsteuer](https://github.com/MarcelLehmann/Lohnsteuer): Java implementation
