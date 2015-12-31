Assignment 1: Matchismo 

Objective
This assignment starts off by asking you to recreate the demonstration given in the second lecture. Not to worry, the posted slides for that lecture contain a detailed walk- through. It is important, however, that you understand what you are doing with each step of that walk-through because the rest of the assignment requires you to add a simple enhancement and your assignment for next week will extend Matchismo even further.

Required Tasks
1. Follow the detailed instructions in the lecture slides (separate document) to build and run Matchismo in the iPhone Simulator in Xcode 5. Do not proceed to the next steps unless your card flips back and forth as expected and builds without warnings or errors.
2. Be sure to include all the code for the four classes shown in the first two lectures: Card, Deck, PlayingCard and PlayingCardDeck. You must type this code in (e.g., do not copy and paste it from somewhere). The whole point of this Required Task is to gain experience editing code in Xcode and to get used to Objective-C syntax.
3. Add a private property of type Deck * to the CardGameViewController.
4. Use lazy instantiation to allocate and initialize this property (in the property’s getter) so that it starts off with a full deck of PlayingCards.
5. Matchismo so far only displays the A♣ over and over. Fix Matchismo so that each time the card is flipped face up, it displays a different random card drawn from theDeck property you’ve created above. In other words, Matchismo should flip through an entire deck of playing cards in random order, showing each card one at a time.6. Do not break the existing functionality in Matchismo (e.g. the Flips counter should still continue to count flips).