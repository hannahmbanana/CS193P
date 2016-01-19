//
//  AnchorBarView.m
//  DropIt
//
//  Created by Hannah Troisi on 1/14/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "AnchorBarView.h"

@implementation AnchorBarView


#pragma mark - Properties

- (void)setPath:(UIBezierPath *)path
{
  _path = path;
  
  // update view every time path is set
  [self setNeedsDisplay];
}


#pragma mark - Lifecycle

- (void)drawRect:(CGRect)rect
{
  [self.path stroke];
}


@end
