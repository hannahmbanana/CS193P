//
//  ViewController.m
//  Imaginarium
//
//  Created by Hannah Troisi on 1/21/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"
#import "BlockingImageViewController.h"
#import "NonBlockingImageViewController.h"

@implementation ViewController
{
  UIButton      *_btn1, *_btn2, *_btn3;
  UISwitch      *_blockingSwitch;
  UILabel       *_blockingLabel;
}


#pragma mark - Lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nil bundle:nil];
  
  if (self) {
    
    // add title to NavItem
    self.navigationItem.title = @"Imaginarium";
    
    // set background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    // configure the image buttons
    _btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [_btn1 setTitle:@"Flower" forState:UIControlStateNormal];
    [_btn2 setTitle:@"Peppers" forState:UIControlStateNormal];
    [_btn3 setTitle:@"Jellyfish" forState:UIControlStateNormal];
    
    // tag helps construct image URL
    [_btn1 setTag:1];
    [_btn2 setTag:2];
    [_btn3 setTag:3];
    
    [_btn1 addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2 addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
    [_btn3 addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];

    // configure block main thread switch & label
    _blockingSwitch     = [[UISwitch alloc] init];
    _blockingSwitch.on  = NO;
    _blockingLabel      = [[UILabel alloc] init];
    _blockingLabel.text = @"Block Main Thread";

    // add views as subviews
    [self.view addSubview:_btn1];
    [self.view addSubview:_btn2];
    [self.view addSubview:_btn3];
    [self.view addSubview:_blockingSwitch];
    [self.view addSubview:_blockingLabel];

  }
  
  return self;
}

static const int BUFFER = 40;

- (void)viewWillLayoutSubviews
{
  // set the frames for the UIButtons
  CGSize boundsSize = self.view.bounds.size;
  
  // size to fit UIControls
  [_btn1 sizeToFit];
  [_btn2 sizeToFit];
  [_btn3 sizeToFit];
  [_blockingLabel sizeToFit];
  
  CGRect btn1Frame = CGRectIntegral( CGRectMake((boundsSize.width - _btn1.frame.size.width)/2,
                                                (boundsSize.height - _btn1.frame.size.height)/2,
                                                 _btn1.frame.size.width,
                                                 _btn1.frame.size.height) );
  
  CGRect btn2Frame = CGRectIntegral( CGRectMake((boundsSize.width - _btn2.frame.size.width)/2,
                                                _btn1.frame.origin.y - BUFFER,
                                                _btn2.frame.size.width,
                                                _btn2.frame.size.height) );
  
  CGRect btn3Frame = CGRectIntegral( CGRectMake((boundsSize.width - _btn3.frame.size.width)/2,
                                                _btn1.frame.origin.y + BUFFER,
                                                _btn3.frame.size.width,
                                                _btn3.frame.size.height) );
  
  CGRect blockingLabelFrame = CGRectIntegral( CGRectMake( (boundsSize.width - _blockingLabel.frame.size.width)/2,
                                                          boundsSize.height - BUFFER * 3,
                                                          _blockingLabel.frame.size.width,
                                                          _blockingLabel.frame.size.height) );
  
  CGRect blockingSwitchFrame = CGRectIntegral( CGRectMake( (boundsSize.width - _blockingSwitch.frame.size.width)/2,
                                                            blockingLabelFrame.origin.y - BUFFER/2 - _blockingSwitch.frame.size.height,
                                                            _blockingSwitch.frame.size.width,
                                                            _blockingSwitch.frame.size.height) );
  
  // set the frames
  _btn1.frame = btn1Frame;
  _btn2.frame = btn2Frame;
  _btn3.frame = btn3Frame;
  _blockingLabel.frame = blockingLabelFrame;
  _blockingSwitch.frame = blockingSwitchFrame;

}

#pragma mark - Button Actions

- (void)showImage:(UIButton *)sender
{
  // create the BlockingImageViewController
  ImageViewController *imageViewController;
  
  if (_blockingSwitch.isOn) {
    imageViewController = [[BlockingImageViewController alloc] init];
  } else {
    imageViewController = [[NonBlockingImageViewController alloc] init];
  }
  
  // set the frame
  imageViewController.view.frame = self.view.bounds;
  
  // set the Nav title
  NSString *photoStringNum = [NSString stringWithFormat:@"photo_%lu", (long)sender.tag];
  imageViewController.navigationItem.title = photoStringNum;
  
  // set the ImageViewController's NSURL
  NSString *photoURL = [NSString stringWithFormat:@"http://www.apple.com/v/iphone-5s/gallery/a/images/download/%@.jpg", photoStringNum];
  imageViewController.imgURL = [NSURL URLWithString:photoURL];
  
  // push the BlockingImageViewController
  [self.navigationController pushViewController:imageViewController animated:YES];
}

@end

