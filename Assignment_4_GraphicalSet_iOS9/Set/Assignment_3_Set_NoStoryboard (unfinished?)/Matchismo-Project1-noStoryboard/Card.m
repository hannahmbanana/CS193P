//
//  Card.m
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
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
