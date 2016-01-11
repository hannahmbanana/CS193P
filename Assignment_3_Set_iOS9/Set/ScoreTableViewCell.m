//
//  ScoreTableViewCell.m
//  Set
//
//  Created by Hannah Troisi on 1/10/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "ScoreTableViewCell.h"

@implementation ScoreTableViewCell
{
  UILabel *_label1;
  UILabel *_label2;
  UILabel *_label3;
  UILabel *_label4;
}


#pragma mark - Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  
  if (self) {
    
    // set the cell's background to be clear
    self.backgroundColor = [UIColor clearColor];
    
    // make it so the cell can't be selected
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // create & add UILabels to cell's content view
    NSInteger score     = [[dictionary objectForKey:@"score"] integerValue];
    NSString *gameType  = [dictionary objectForKey:@"gameType"];
    NSDate   *start     = [dictionary objectForKey:@"start"];
    NSDate   *end       = [dictionary objectForKey:@"end"];
    
    if (score > 0) {
      _label1 = [[self class] labelWithString:[NSString stringWithFormat:@" %ld", (long)score]];
    } else {
      _label1 = [[self class] labelWithString:[NSString stringWithFormat:@"%ld", (long)score]];
    }
    
    _label2 = [[self class] labelWithString:gameType];
    
    NSTimeInterval duration = [end timeIntervalSinceDate:start];
    NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
    
    _label3 = [[self class] labelWithString:[formatter stringFromTimeInterval:duration]];
    
    _label4 = [[self class] labelWithString:[NSDateFormatter localizedStringFromDate:start
                                                                           dateStyle:NSDateFormatterShortStyle
                                                                           timeStyle:NSDateFormatterShortStyle]];

    [self.contentView addSubview:_label1];
    [self.contentView addSubview:_label2];
    [self.contentView addSubview:_label3];
    [self.contentView addSubview:_label4];
  }
  
  return self;
}

- (void)layoutSubviews
{
  CGSize cellSize = self.bounds.size;
  _label1.frame = CGRectMake( 0,                            0, roundf(cellSize.width * 1/6),  cellSize.height );
  _label2.frame = CGRectMake( roundf(cellSize.width * 1/6), 0, roundf(cellSize.width * 1/6),  cellSize.height );
  _label3.frame = CGRectMake( roundf(cellSize.width * 2/6), 0, roundf(cellSize.width * 2/6),  cellSize.height );
  _label4.frame = CGRectMake( roundf(cellSize.width * 4/6), 0, roundf(cellSize.width * 2/6),  cellSize.height );
}


#pragma mark - Helper Methods
+ (UILabel *)labelWithString:(NSString *)string
{
  UILabel *label = [[UILabel alloc] init];
  
  label.text = string;
  label.textColor = [UIColor whiteColor];
  
  return label;
}

@end
