# Cards

An implementation of a deck of playing cards, including logic for a number of well-known games.

This package is split into several targets.

There are core targets that can be used across a number of card games:
- `CardsModel`: the basic model including suit and card values
- `CardsScoring`: implementations of scoring including treating aces as both high and low
- `CardsStyle`: visual implementations of cards, including public domain assets

Then there are game targets which implement a specific card game:
- [`Sevens` (also known as Domino)](https://en.wikipedia.org/wiki/Domino_(card_game))
- [`Go Fish`: *Work in Progress*](https://en.wikipedia.org/wiki/Go_Fish)
- [`Hearts`: *Work in Progress*](https://en.wikipedia.org/wiki/Hearts_(card_game))
