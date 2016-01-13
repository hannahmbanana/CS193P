//
//  SetCard.h
//  Matchismo
//
//  Created by Hannah Troisi on 10/14/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "Card.h"
@import UIKit;

@interface SetCard : Card

@property (strong, nonatomic) NSString *shape;
@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) NSString *shade;

+ (NSArray *)validShapes;
+ (NSUInteger)maxNumber;
+ (NSArray *)validColors;
+ (NSArray *)validShades;

@end
