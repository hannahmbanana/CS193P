//
//  PlayingCardView.h
//  Set
//
//  Created by Hannah Troisi on 1/10/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//


#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic, strong, readwrite) NSString   *suit;
@property (nonatomic, assign, readwrite) NSUInteger rank;

@end
