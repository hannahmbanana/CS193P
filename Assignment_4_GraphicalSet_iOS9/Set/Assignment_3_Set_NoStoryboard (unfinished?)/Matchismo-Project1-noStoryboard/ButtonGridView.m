//
//  ButtonGridView.m
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "ButtonGridView.h"

@implementation ButtonGridView
{
    NSUInteger _columnCount;
    NSUInteger _rowCount;
}

@synthesize cardButtonArray = _cardButtonArray;

- (instancetype) initWithColumns:(NSUInteger)columnCount
                            rows:(NSUInteger)rowCount
{
    self = [super init];
    
    if (self) {
        
        NSMutableArray *cardButtonArray = [[NSMutableArray alloc] init];
        
        // add the correct number of buttons to the array
        for (int i=0; i < columnCount * rowCount; i++) {
            
            // create the button
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            // set the button text color
            [btn setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
            
            // add the button to the subview & array
            [self addSubview:btn];
            [cardButtonArray addObject:btn];
        }
        
        _cardButtonArray = cardButtonArray; // assign NSMutableArray to NSArray
        _columnCount = columnCount;  // need this in layoutSubviews
        _rowCount = rowCount;  // need this in layoutSubviews
    }
    
    return self;
}

// FIXME: auto layout
static const int CARD_HEIGHT = 60;
static const int CARD_WIDTH = 40;
static const int HORIZONTAL_INSET = 20;
static const int VERTICAL_INSET = 30;
static const int CARD_BUFFER = 8;

- (void)layoutSubviews
{
    for (UIButton *button in self.cardButtonArray) {
        
        NSUInteger buttonIndex = [self.cardButtonArray indexOfObject:button];
        NSUInteger cardColumnPosition = buttonIndex % _columnCount;
        NSUInteger cardRowPosition = buttonIndex / _columnCount;
        
        CGFloat xPosition = HORIZONTAL_INSET +
                            cardColumnPosition * CARD_WIDTH +
                            cardColumnPosition * CARD_BUFFER;
        
        CGFloat yPosition = VERTICAL_INSET +
                            cardRowPosition * CARD_HEIGHT +
                            cardRowPosition * CARD_BUFFER;
        
        //FIXME: understand frame vs bounds
        button.frame = CGRectMake(xPosition, yPosition,
                                  CARD_WIDTH, CARD_HEIGHT);
        
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat width = _columnCount * CARD_WIDTH +
                    (_columnCount - 1) * CARD_BUFFER +
                    HORIZONTAL_INSET * 2;
    CGFloat height = _rowCount * CARD_HEIGHT +
                    (_rowCount - 1) * CARD_BUFFER +
                    VERTICAL_INSET * 2;
    
    return CGSizeMake(width,height);
}

@end
