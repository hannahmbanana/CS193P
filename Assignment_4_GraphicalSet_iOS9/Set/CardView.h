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
@property (nonatomic, assign, readwrite) Card *card;

- (void)updateCardProperties;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

+ (CGSize)preferredCardSizeForWidth:(CGFloat)width;
- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;

@end
