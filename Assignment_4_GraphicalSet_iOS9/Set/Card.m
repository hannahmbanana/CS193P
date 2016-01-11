//
//  Card.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "Card.h"

@implementation Card


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
