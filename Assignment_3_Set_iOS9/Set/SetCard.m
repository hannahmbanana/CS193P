//
//  SetCard.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

# pragma mark - Properties

// override the shape setter to make sure it's a valid shape
- (void)setShape:(NSString *)shape
{
  if ([[SetCard validShapes] containsObject:shape]) {
    _shape = shape;
  }
}

// override the number setter to make sure it's a valid number
- (void)setNumber:(NSUInteger)number
{
  if (number <= [SetCard maxNumber]) {
    _number = number;
  }
}

// override the color setter to make sure it's a valid color
- (void)setColor:(UIColor *)color
{
  if ([[SetCard validColors] containsObject:color]) {
    _color = color;
  }
}

// override the shading setter to make sure it's a valid shade
- (void)setShade:(NSString *)shade
{
  if ([[SetCard validShades] containsObject:shade]) {
    _shade = shade;
  }
}


#pragma mark - Instance Methods

// override superclass' match method
- (int)match:(NSArray *)otherCards
{
  // call class method
  return [SetCard match:[otherCards arrayByAddingObject:self]];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%lu-%@-%@-%@", self.number, self.shade, [self.shape description], [self.color description]];
}

#pragma mark - Class Methods

+ (int)match:(NSArray *)cards
{
  BOOL match = YES;
  
  // points if they all match or if they all don't match
  if ( ![SetCard cardAttributeSet:cards withProperty:@selector(shape)] )
    match = NO;
  if ( ![SetCard cardAttributeSet:cards withProperty:@selector(number)] )
    match = NO;
  if ( ![SetCard cardAttributeSet:cards withProperty:@selector(color)] )
    match = NO;
  if ( ![SetCard cardAttributeSet:cards withProperty:@selector(shade)] )
    match = NO;
  
  return match ? 1 : 0;;
}

+ (NSUInteger)cardAttributeSet:(NSArray *)cards withProperty:(SEL)property
{
  NSMutableSet *shapeSet = [NSMutableSet set];
  
  for (SetCard *card in cards) {
    if (property == @selector(number)) {
      [shapeSet addObject:[NSNumber numberWithUnsignedInteger:card.number]];
    } else {
      [shapeSet addObject:[card performSelector:property]];
    }
  }
  
  BOOL match = YES;
  
  if ([shapeSet count] == 2)
    match = NO;
  
  return match;
}

+ (NSArray *)validShapes
{
  return @[@"▲", @"●", @"■"];
}

+ (NSUInteger)maxNumber
{
  return 3;
}

+ (NSArray *)validColors
{
  return @[[UIColor colorWithRed:252.0f/255.0f green:4.0f/255.0f blue:118.0f/255.0f alpha:1.0f],
           [UIColor colorWithRed:85.0f/255.0f green:70.0f/255.0f blue:151.0f/255.0f alpha:1.0f],
           [UIColor colorWithRed:85.0f/255.0f green:218.0f/255.0f blue:89.0f/255.0f alpha:1.0f]];
}

+ (NSArray *)validShades
{
  return @[@"solid", @"striped", @"open"];
}

@end
