//
//  SetCardView.h
//  Set
//
//  Created by Hannah Troisi on 1/10/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView

@property (nonatomic, strong, readwrite) NSString   *shape;
@property (nonatomic, strong, readwrite) NSString   *color;
@property (nonatomic, strong, readwrite) NSString   *fill;
@property (nonatomic, assign, readwrite) NSUInteger number;

@end
