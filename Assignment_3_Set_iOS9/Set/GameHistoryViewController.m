//
//  GameHistoryViewController.m
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "GameHistoryViewController.h"

@implementation GameHistoryViewController
{
  UITextView *_textView;
}

#pragma mark - Lifecycle

- (instancetype)initWithPlayHistoryString:(NSMutableAttributedString *)historyString
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
    
  }
  
  return self;
}

- (void)viewDidLoad
{
  self.view.backgroundColor = [UIColor colorWithRed:15/255.0 green:110/255.0 blue:48/255.0 alpha:1];
  
  [self.view addSubview:_textView];
}

- (void)viewWillLayoutSubviews
{
  _textView.frame = self.view.bounds;
  _textView.backgroundColor = [UIColor clearColor];
}


@end
