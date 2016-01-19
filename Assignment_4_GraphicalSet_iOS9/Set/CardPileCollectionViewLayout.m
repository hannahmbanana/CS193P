//
//  CardPileCollectionViewLayout.m
//  Set
//
//  Created by Hannah Troisi on 1/17/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "CardPileCollectionViewLayout.h"

@interface CardPileCollectionViewLayout ()

@property (nonatomic, strong, readwrite) NSMutableArray *itemAttributes;
@property (nonatomic, assign, readwrite) CGSize         contentSize;

@end

@implementation CardPileCollectionViewLayout

#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    [self setItemOffset:UIOffsetMake(100, 100)];
  }
  return self;
}

// called when the CollectionView presents itself for the first time and each time the layout is invalidated
- (void)prepareLayout
{
  
  // reset itemAttributes
  [self setItemAttributes:nil];
  _itemAttributes = [[NSMutableArray alloc] init];
  
  NSUInteger column = 0;    // Current column inside row
  
  CGFloat xOffset = _itemOffset.horizontal;
  CGFloat yOffset = _itemOffset.vertical;
  CGFloat rowHeight = 10.0;
  CGFloat colHeight = 6.0;
//  
  CGFloat contentWidth = 0.0;         // Used to determine the contentSize
  CGFloat contentHeight = 0.0;        // Used to determine the contentSize
  
  // We'll create a dynamic layout. Each row will have a random number of columns
  NSUInteger numberOfColumnsInRow = arc4random() % 10;
//  NSLog(@"%lu", numberOfColumnsInRow);
  
  // calculate the UICollectionViewLayoutAttributes for each item in the UICollectionView
  NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
  
  for (NSUInteger index = 0; index < numberOfItems; index++)
  {
    CGSize itemSize = [self sizeForItem];
    
    // Create the actual UICollectionViewLayoutAttributes and add it to your array. We'll use this later in layoutAttributesForItemAtIndexPath:
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
//    NSLog(@"frame = %@", NSStringFromCGRect(frame));
    attributes.frame = CGRectIntegral(frame);
    attributes.transform = CGAffineTransformMakeRotation( arc4random_uniform(360) / 180.0 * 3.14159 );
    [_itemAttributes addObject:attributes];
    
    xOffset += colHeight;
    column++;
    
    // Create a new row if this was the last column
    if (column >= numberOfColumnsInRow)
    {
      if (xOffset > contentWidth)
        contentWidth = xOffset;
      
      // Reset values
      column = 0;
      xOffset = _itemOffset.horizontal;
      yOffset += rowHeight;
      
      // Determine how much columns the new row will have
      numberOfColumnsInRow = arc4random() % 7;
//      NSLog(@"%lu", numberOfColumnsInRow);
    }
  }
  
  // Get the last item to calculate the total height of the content
  UICollectionViewLayoutAttributes *attributes = [_itemAttributes lastObject];
  contentHeight = attributes.frame.origin.y+attributes.frame.size.height;
  
  // Return this in collectionViewContentSize
  _contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (CGSize)collectionViewContentSize
{
  return _contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return [_itemAttributes objectAtIndex:indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
  NSLog(@"rect = %@", NSStringFromCGRect(rect));
  return [_itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
    return CGRectIntersectsRect(rect, [evaluatedObject frame]);
  }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
  return NO;
}

#pragma mark - Helpers

- (CGSize)sizeForItem
{
  return CGSizeMake(40,60);
}


@end
