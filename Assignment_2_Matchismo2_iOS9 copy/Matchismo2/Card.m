//
//  Card.m
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize contents = _contents;
@synthesize chosen = _chosen;
@synthesize matched = _matched;


#pragma mark - Instance Methods

- (int)match:(NSArray *)otherCards
{
  int score = 0;
  
  for (Card *otherCard in otherCards) {
    if ([self.contents isEqualToString:otherCard.contents]) {
      score++;
    }
  }
  
  return score;
}

@end
