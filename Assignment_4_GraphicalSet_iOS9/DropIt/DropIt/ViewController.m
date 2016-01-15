//
//  ViewController.m
//  DropIt
//
//  Created by Hannah Troisi on 1/14/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ViewController.h"
#import "DropItBehavior.h"
#import "AnchorBarView.h"

@interface ViewController () <UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>

@property (nonatomic, assign, readwrite) CGFloat              dropSize;
@property (nonatomic, strong, readwrite) UIView               *droppingView;
@property (nonatomic, strong, readwrite) UIDynamicAnimator    *animator;
@property (nonatomic, strong, readwrite) DropItBehavior       *dropItBehavior;
@property (nonatomic, strong, readwrite) UIAttachmentBehavior *attachmentBehavior;
@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)loadView
{
  // create anchorBarView
  self.view = [[AnchorBarView alloc] init];
  
  // create a UITapGestureRecognizer & add it to the view
  UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropCube)];
  [self.view addGestureRecognizer:tgr];
  
  // create a UIPanGestureRecognizer & add it to the view
  UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCube:)];
  [self.view addGestureRecognizer:pgr];
  
  // create a UIDynamicAnimator
  self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
  self.animator.delegate = self;
  
  // create a DropItBehavior and add it to the animator
  self.dropItBehavior = [[DropItBehavior alloc] init];
  [self.animator addBehavior:self.dropItBehavior];
}

#pragma mark - Touch Handling

- (void)dropCube
{
  // setup dropCube frame
  CGFloat dropSize = self.view.bounds.size.width / 8;
  self.dropSize = dropSize;
  
  CGPoint origin = CGPointZero;
  origin.x = arc4random_uniform(self.view.bounds.size.width / dropSize) * dropSize;
  
  CGSize size = CGSizeMake(dropSize, dropSize);
  CGRect frame = (CGRect) {origin, size};
  
  // create dropCube UIView
  UIView *dropView = [[UIView alloc] initWithFrame:frame];
  dropView.backgroundColor = [self randomColor];
  
  // add dropCube to self.view
  [self.view addSubview:dropView];
  
  // add dropCube to the UIDynamicBehaviors
  [self.dropItBehavior addItem:dropView];
  
  // set dropCube to be the droppingView
  self.droppingView = dropView;
}

- (void)moveCube:(UIPanGestureRecognizer *)sender
{
  // find coordinates of gesture
  CGPoint gesturePoint = [sender locationInView:self.view];
  
  if (sender.state == UIGestureRecognizerStateBegan) {
    
    [self attachDropingViewToPoint:gesturePoint];
    
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    
    // change anchor point to new gesture location
    self.attachmentBehavior.anchorPoint = gesturePoint;
    
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    
    // remove anchorBarView path
    AnchorBarView *view = (AnchorBarView *)self.view;
    [view setPath:nil];
    
    // remove attachment behavior from animator
    [self.animator removeBehavior:self.attachmentBehavior];
  }
}


#pragma mark - Helper Methods

- (void)attachDropingViewToPoint:(CGPoint)anchorPoint
{
  if (self.droppingView) {
    
    // create attachment behavior
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:anchorPoint];
    
    UIView *droppingView = self.droppingView;     // copy of self.dropping view (gets set to nil below)
    __weak ViewController *weakSelf = self;       // to avoid retain cycle
    self.attachmentBehavior.action = ^{
      UIBezierPath *path = [[UIBezierPath alloc] init];
      [path moveToPoint:weakSelf.attachmentBehavior.anchorPoint];  // need to use current value, not method arg
      [path addLineToPoint:droppingView.center];
      AnchorBarView *view = (AnchorBarView *)weakSelf.view;
      [view setPath:path];
    };
    
    // add attachment behavior to animator
    [self.animator addBehavior:self.attachmentBehavior];
    
    // don't allow the user to attach to the droppingView again
    self.droppingView = nil;
  }
}

- (UIColor *)randomColor
{
  switch (arc4random_uniform(6))
  {
    case 0: return [UIColor greenColor];
    case 1: return [UIColor redColor];
    case 2: return [UIColor orangeColor];
    case 3: return [UIColor yellowColor];
    case 4: return [UIColor blueColor];
    case 5: return [UIColor purpleColor];
  }
  return [UIColor blackColor];
}

- (BOOL)removeCompletedRows
{
  NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
  
  CGFloat dropSize = self.dropSize;
  
  // find drops to remove
  for (CGFloat y = self.view.bounds.size.height - dropSize/2; y > 0; y -= dropSize)
  {
    BOOL rowIsComplete = YES;
    NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
    
    for (CGFloat x = dropSize/2; x <= self.view.bounds.size.width-dropSize/2; x += dropSize)
    {
      UIView *hitView = [self.view hitTest:CGPointMake(x,y) withEvent:NULL];
      
      if ([hitView superview] == self.view) {
        [dropsFound addObject:hitView];
      } else {
        rowIsComplete = NO;
        break;
      }
    }
    
    if (![dropsFound count]) break;
    if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
  }
  
  // remove found drops from DropItBehavior
  if ([dropsToRemove count]) {
    for (UIView *drop in dropsToRemove) {
      [self.dropItBehavior removeItem:drop];
    }
    
    // animate the removing of the drops
    [self animateRemovingDrops:dropsToRemove];
  }
  
  return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropsToRemove
{
  [UIView animateWithDuration:1.0 animations:^{
    for (UIView *drop in dropsToRemove) {
      int x = arc4random_uniform(self.view.bounds.size.width*5) - self.view.bounds.size.width*2;
      int y = self.view.bounds.size.height;
      drop.center = CGPointMake(x, -y);
    }
  } completion:^(BOOL finished) {
    if (finished) {
      // remove the drops from their superview
      [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
  }];
}


#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2
{
  
}


#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
  [self removeCompletedRows];
}

@end
