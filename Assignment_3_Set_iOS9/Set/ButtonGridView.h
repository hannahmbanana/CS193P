//
//  ButtonGridView.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonGridView;
@protocol ButtonGridViewDelegate <NSObject>
@required
- (void)touchCardButtonAtIndex:(NSUInteger)index;
- (NSAttributedString *)attributedTitleForCardAtIndex:(NSUInteger)index;
- (UIImage *)backgroundImageForCardAtIndex:(NSUInteger)index;
- (BOOL)shadowForCardAtIndex:(NSUInteger)index;
- (BOOL)enableCardAtIndex:(NSUInteger)index;
- (CGFloat)alphaForCardAtIndex:(NSUInteger)index;
@end

@interface ButtonGridView : UIView

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithColumns:(NSUInteger)columnCount
                           rows:(NSUInteger)rowCount
                       delegate:(id<ButtonGridViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (CGSize)preferredSizeForWidth:(CGFloat)width;
- (void)updateBtnCards;

@end
