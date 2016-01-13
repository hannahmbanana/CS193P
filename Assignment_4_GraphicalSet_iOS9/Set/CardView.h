//
//  CardView.h
//  Set
//
//  Created by Hannah Troisi on 1/10/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

// ABSTRACT CLASS
@interface CardView : UIView

@property (nonatomic, assign, readwrite) BOOL faceUp;

- (instancetype)initWithFrame:(CGRect)frame card:(Card *)card;

- (void)updateCardProperties:(Card *)card;

+ (CGSize)preferredCardSizeForWidth:(CGFloat)width;
- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;

@end
