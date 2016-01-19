//
//  CardPileCollectionViewLayout.h
//  Set
//
//  Created by Hannah Troisi on 1/17/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardPileCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign, readwrite) UIOffset itemOffset;

- (CGSize)collectionViewContentSize;

@end
