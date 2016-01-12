//
//  SetCardView.h
//  CustomCards-Project4
//
//  Created by Hannah Troisi on 10/22/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView

@property (nonatomic, strong, readwrite) NSString   *shape;
@property (nonatomic, strong, readwrite) NSString   *color;
@property (nonatomic, strong, readwrite) NSString   *fill;
@property (nonatomic, assign, readwrite) NSUInteger number;

@end
