//
//  DropItBehavior.m
//  DropIt
//
//  Created by Hannah Troisi on 1/14/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "DropItBehavior.h"

@interface DropItBehavior ()

@property (nonatomic, strong, readwrite) UIGravityBehavior      *gravity;
@property (nonatomic, strong, readwrite) UICollisionBehavior    *collision;
@property (nonatomic, strong, readwrite) UIDynamicItemBehavior  *nonRotatingBehavior;

@end

@implementation DropItBehavior


- (instancetype)init
{
  self = [super init];
  
  if (self) {
    
    // setup UIDynamicBehaviors
    self.gravity = [[UIGravityBehavior alloc] init];
    [self addChildBehavior:self.gravity];
    
    self.collision = [[UICollisionBehavior alloc] init];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self addChildBehavior:self.collision];
    
    self.nonRotatingBehavior = [[UIDynamicItemBehavior alloc] init];
    self.nonRotatingBehavior.allowsRotation = NO;
    [self addChildBehavior:self.nonRotatingBehavior];
  }
  
  return self;
}

- (void)addItem:(id <UIDynamicItem>)item
{
  [self.gravity addItem:item];
  [self.collision addItem:item];
  [self.nonRotatingBehavior addItem:item];
}

- (void)removeItem:(id <UIDynamicItem>)item
{
  [self.gravity removeItem:item];
  [self.collision removeItem:item];
  [self.nonRotatingBehavior removeItem:item];
}


@end
