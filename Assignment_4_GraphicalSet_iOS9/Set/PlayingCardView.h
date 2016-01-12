//
//  PlayingCardView.h
//  CustomCards-Project4
//
//  Created by Hannah Troisi on 10/22/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic, strong, readwrite) NSString   *suit;
@property (nonatomic, assign, readwrite) NSUInteger rank;

@end
