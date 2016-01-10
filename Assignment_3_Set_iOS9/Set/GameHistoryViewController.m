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
    // create the UITextView
    _textView = [[UITextView alloc] init];
    
    // configure the UITextView
    _textView.textAlignment = NSTextAlignmentCenter;
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _textView.backgroundColor = [UIColor colorWithRed:15/255.0 green:110/255.0 blue:48/255.0 alpha:1];
    
    // set the UITextView's text
    if (!historyString.length) {
      [_textView setText:@"No matches / mismatches yet"];
    } else {
      [_textView setAttributedText:historyString];
    }
  }
  
  return self;
}

- (void)viewDidLoad
{
  [self.view addSubview:_textView];
}

- (void)viewWillLayoutSubviews
{
  _textView.frame = self.view.bounds;
}

@end
