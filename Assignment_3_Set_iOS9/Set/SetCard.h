//
//  SetCard.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "Card.h"
@import UIKit;

@interface SetCard : Card

@property (nonatomic, strong, readwrite) NSString    *shape;
@property (nonatomic, assign, readwrite) NSUInteger  number;
@property (nonatomic, strong, readwrite) UIColor     *color;
@property (nonatomic, strong, readwrite) NSString    *shade;

+ (NSArray *)validShapes;
+ (NSUInteger)maxNumber;
+ (NSArray *)validColors;
+ (NSArray *)validShades;

@end
