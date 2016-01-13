//
//  CardMatchingGame.h
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchingGame.h"

@interface CardMatchingGame : MatchingGame

// overwrites superclass's definition
- (void)choseCardAtIndex:(NSUInteger)index;

@end
