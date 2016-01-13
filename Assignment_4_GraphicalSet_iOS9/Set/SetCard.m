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
- (void)setColor:(NSString *)color
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
  BOOL isMatch = [SetCard match:[otherCards arrayByAddingObject:self]];
  return isMatch ? 1 : 0;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%lu-%@-%@-%@", (unsigned long)self.number, self.shade, [self.shape description], [self.color description]];
}

#pragma mark - Class Methods

+ (BOOL)match:(NSArray <SetCard *> *)cards
{
  NSMutableSet *shapeSet  = [NSMutableSet set];
  NSMutableSet *colorSet  = [NSMutableSet set];
  NSMutableSet *shadeSet  = [NSMutableSet set];
  NSMutableSet *numberSet = [NSMutableSet set];
  
  for (SetCard *setCard in cards) {
    [shapeSet addObject:[setCard shape]];
    [colorSet addObject:[setCard color]];
    [shadeSet addObject:[setCard shade]];
    [numberSet addObject:[NSNumber numberWithUnsignedInteger:[setCard number]]];
  }
  
  NSArray *propertySets = @[shapeSet, colorSet, shadeSet, numberSet];
  
  BOOL isMatch = YES;
  for (NSSet *set in propertySets) {
    isMatch = isMatch && (set.count == 1 || set.count == cards.count);
  }
  
  return isMatch;
}

+ (NSArray *)validShapes
{
  return @[@"diamond", @"oval", @"squiggle"];
}

+ (NSUInteger)maxNumber
{
  return 3;
}

+ (NSArray *)validColors
{
  return @[@"pink", @"purple", @"green"];
//  return @[[UIColor colorWithRed:252.0f/255.0f green:004.0f/255.0f blue:118.0f/255.0f alpha:1.0f],
//           [UIColor colorWithRed:085.0f/255.0f green:070.0f/255.0f blue:151.0f/255.0f alpha:1.0f],
//           [UIColor colorWithRed:085.0f/255.0f green:218.0f/255.0f blue:089.0f/255.0f alpha:1.0f]];
}

+ (NSArray *)validShades
{
  return @[@"solid", @"striped", @"unfilled"];
}

@end
