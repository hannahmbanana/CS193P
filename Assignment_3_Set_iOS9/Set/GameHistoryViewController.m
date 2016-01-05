//
//  GameHistoryViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController ()

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
              playHistoryString:(NSMutableAttributedString *)historyString NS_DESIGNATED_INITIALIZER;

@end

@implementation GameHistoryViewController
{
  UITextView *_textView;
}

#pragma mark - Lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil { @throw nil; }

- (instancetype)initWithCoder:(NSCoder *)aDecoder { @throw nil; }

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
              playHistoryString:(NSMutableAttributedString *)historyString
{
  self = [super initWithNibName:nil bundle:nil];
  
  if (self) {
    
    _textView = [[UITextView alloc] init];
    
    if (!historyString.length) {
      [_textView setText:@"No History Yet"];
    } else {
      [_textView setAttributedText:historyString];
      // FIXME: yourTextField.text = [yourArray componentsJoinedByString:@"\n"];
    }
    _textView.textAlignment = NSTextAlignmentCenter;
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor redColor];  //]colorWithRed:15/255.0 green:110/255.0 blue:48/255.0 alpha:1];

    
    // FIXME: put newest at top by reversing array
    // NSArray* reversedArray = [[startArray reverseObjectEnumerator] allObjects];
    
  }
  
  return self;
}

- (void)viewDidLoad
{
  [self.view addSubview:_textView];
}

- (void)viewWillLayoutSubviews
{
  CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
  CGRect tabBarFrame = self.tabBarController.tabBar.frame;
  _textView.frame = CGRectMake(0,
                               CGRectGetMaxY(navigationBarFrame),
                               self.view.bounds.size.width,
                               CGRectGetMinY(tabBarFrame) - CGRectGetMaxY(navigationBarFrame));
}


@end
