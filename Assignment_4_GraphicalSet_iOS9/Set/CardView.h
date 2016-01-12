//
//  CardView.h
//  CustomCards-Project4
//
//  Created by Hannah Troisi on 10/22/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

// ABSTRACT CLASS
@interface CardView : UIView

@property (nonatomic, assign, readwrite) BOOL faceUp;

+ (CGSize)preferredCardSizeForWidth:(CGFloat)width;
- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;

// subclass must implement
- (void)tappedCard:(UIGestureRecognizer *)gestureRecognizer;
- (void)tappedCardTwice:(UIGestureRecognizer *)gestureRecognizer;
- (void)tappedCardThrice:(UIGestureRecognizer *)gestureRecognizer;
- (void)tappedCardQuarce:(UIGestureRecognizer *)gestureRecognizer;

@end
