//
//  Card.h
//  Matchismo
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong)           NSString  *contents;
@property (nonatomic, getter=isChosen)  BOOL      chosen;
@property (nonatomic, getter=isMatched) BOOL      matched;

- (int)match:(NSArray *)otherCards;

@end

