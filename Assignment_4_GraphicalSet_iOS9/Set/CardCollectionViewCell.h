//
//  CardCollectionViewCell.h
//  Set
//
//  Created by Hannah Troisi on 1/17/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface CardCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readwrite, nullable) Card *card;

@end
