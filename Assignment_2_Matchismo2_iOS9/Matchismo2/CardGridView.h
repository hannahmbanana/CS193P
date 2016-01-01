//
//  CardGridView.h
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardGridView;
@protocol CardGridViewDelegate <NSObject>
@required
- (void)touchCardButton:(UIButton *)sender;
@end

@interface CardGridView : UIView

@property (nonatomic, strong, readonly) NSArray                   *cardButtonArray;
@property (nonatomic, strong)           id<CardGridViewDelegate>  delegate;

- (CGSize)preferredSizeForWidth:(CGFloat)width;

- (instancetype)initWithColumns:(NSUInteger)columnCount rows:(NSUInteger)rowCount delegate:(id<CardGridViewDelegate>)delegate;

@end
