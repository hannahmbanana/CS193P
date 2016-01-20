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
  UILabel *_scorelabel;
  UILabel *_typeLabel;
  UILabel *_durationLabel;
  UILabel *_dateLabel;
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
    NSInteger score      = [[dictionary objectForKey:@"score"] integerValue];
    NSString  *gameType  = [dictionary objectForKey:@"gameType"];
    NSDate    *start     = [dictionary objectForKey:@"start"];
    NSDate    *end       = [dictionary objectForKey:@"end"];
    
    // score label
    NSString *formatString = (score > 0) ? @" %ld" : @"%ld";
    _scorelabel = [[self class] labelWithString:[NSString stringWithFormat:formatString, (long)score]];
    
    // game type label
    _typeLabel = [[self class] labelWithString:gameType];
    
    // game duration label
    NSTimeInterval duration = [end timeIntervalSinceDate:start];
    NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
    _durationLabel = [[self class] labelWithString:[formatter stringFromTimeInterval:duration]];
    
    // date label
    _dateLabel = [[self class] labelWithString:[NSDateFormatter localizedStringFromDate:start
                                                                              dateStyle:NSDateFormatterShortStyle
                                                                              timeStyle:NSDateFormatterShortStyle]];

    // add subviews to cell's contentView
    [self.contentView addSubview:_scorelabel];
    [self.contentView addSubview:_typeLabel];
    [self.contentView addSubview:_durationLabel];
    [self.contentView addSubview:_dateLabel];
  }
  
  return self;
}

- (void)layoutSubviews
{
  CGSize cellSize = self.bounds.size;
  
  _scorelabel.frame     = CGRectIntegral( CGRectMake( 0,                    0, cellSize.width * 1/6,  cellSize.height ));
  _typeLabel.frame      = CGRectIntegral( CGRectMake( cellSize.width * 1/6, 0, cellSize.width * 1/6,  cellSize.height ));
  _durationLabel.frame  = CGRectIntegral( CGRectMake( cellSize.width * 2/6, 0, cellSize.width * 2/6,  cellSize.height ));
  _dateLabel.frame      = CGRectIntegral( CGRectMake( cellSize.width * 4/6, 0, cellSize.width * 2/6,  cellSize.height ));
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
