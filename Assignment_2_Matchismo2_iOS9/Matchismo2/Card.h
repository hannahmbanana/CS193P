//
//  Card.h
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong)                   NSString  *contents;
@property (nonatomic, assign, getter=isChosen)  BOOL      chosen;
@property (nonatomic, assign, getter=isMatched) BOOL      matched;

- (int)match:(NSArray *)otherCards;

@end