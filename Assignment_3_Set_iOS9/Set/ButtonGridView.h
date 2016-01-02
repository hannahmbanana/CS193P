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
- (void)touchCardButton:(UIButton *)sender;
@end

@interface ButtonGridView : UIView

@property (nonatomic, strong, readonly) NSArray *cardButtonArray;

- (instancetype)initWithColumns:(NSUInteger)columnCount rows:(NSUInteger)rowCount delegate:(id<ButtonGridViewDelegate>)delegate;
- (CGSize)preferredSizeForWidth:(CGFloat)width;

@end
