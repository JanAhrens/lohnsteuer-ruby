# Lohnsteuer

This is a Ruby implementation of the german income tax calculation
algorithm.

The algorithm gets updated every year (sometimes multiple times a year).
Currently following implementations are supported:

* Lst1215 (for December 2015)
* Lst2016 (for 2016)

The algorithms where implemented by translating the program flowcharts
published by the [Bundesministerium der Finananzen](https://www.bmf-steuerrechner.de/)
into Ruby code.
The algorithms weren't modified on purpose to enable updates and verification.

**State of the project**: Experimental. The interface needs to stabilize.

## Related projects

* [vschoettke/node-lohnsteuer](https://github.com/vschoettke/lohnsteuer): Node.js implementation
* [MarcelLehmann/Lohnsteuer](https://github.com/MarcelLehmann/Lohnsteuer): Java implementation
