//
//  PlayingCard.m
//  Matchismo
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;
@synthesize rank = _rank;

// override superclass' contents getter
- (NSString *)contents
{
  // to get playing card rank out of ints (e.g. K out of 13)
  NSArray *rankStrings = [PlayingCard rankStrings];
  
  return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

// override the suit getter - nil (not yet set) will return a "?"
- (NSString *)suit
{
  return _suit ? _suit : @"?";
}

// override the suit setter to make sure it's not set to something invalid
- (void)setSuit:(NSString *)suit
{
  if ([[PlayingCard validSuits] containsObject:suit]) {
    _suit = suit;
  }
}

// override rank setter
- (void)setRank:(NSUInteger)rank
{
  if (rank <= [PlayingCard maxRank]) {
    _rank = rank;
  }
}

+ (NSArray *)rankStrings
{
  return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
           @"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSArray *)validSuits
{
  return @[@"♧", @"♤", @"♡", @"♢"];
}

+ (NSUInteger)maxRank
{
  return [[self rankStrings] count] -1;
}

@end
