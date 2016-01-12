//
//  PlayingCardView.m
//  CustomCards-Project4
//
//  Created by Hannah Troisi on 10/22/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView


#pragma mark - Properties

- (void)setSuit:(NSString *)suit
{
  _suit = suit;
  [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank
{
  _rank = rank;
  [self setNeedsDisplay];
}

- (NSString *)rankAsString
{
  return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

#pragma mark - Drawing

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)pushContextAndRotateUpsideDown
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawCorners
{
  // create NSAttributedString attributes dictionary
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  
  UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
  
  NSDictionary *attributes = @{ NSFontAttributeName : cornerFont,
                                NSParagraphStyleAttributeName : paragraphStyle};
  
  // create NSAttributedString with corner text
  NSString *cornerString = [NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit];
  NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:cornerString
                                                                   attributes:attributes];
  
  // draw NSAttributedString in top left corner
  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [cornerText size];
  
  [cornerText drawInRect:textBounds];
  
  // translate and draw in bottom right corner
  [self pushContextAndRotateUpsideDown];
  [cornerText drawInRect:textBounds];
  [self popContext];
  
}

- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
  if (self.faceUp) {
    
    // check if the card is a facecard (J,Q,K)
    UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
    
    if (faceImage) {
      
      // draw face on center of card
      CGRect faceImageRect = CGRectInset(self.bounds,
                                         self.bounds.size.width * (1.0-DEFAULT_FACE_CARD_SCALE_FACTOR),
                                         self.bounds.size.height * (1.0-DEFAULT_FACE_CARD_SCALE_FACTOR));
      [faceImage drawInRect:faceImageRect];
      
    } else {
      // draw suit on center of card
      [self drawPips];
    }
    
    // draw the corner content
    [self drawCorners];
    
  } else {
    [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
  }
}

#pragma mark - Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
  if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:PIP_VOFFSET2_PERCENTAGE
                    mirroredVertically:(self.rank != 7)];
  }
  if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET3_PERCENTAGE
                    mirroredVertically:YES];
  }
  if ((self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET1_PERCENTAGE
                    mirroredVertically:YES];
  }
}

#define PIP_FONT_SCALE_FACTOR 0.012

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
  if (upsideDown) [self pushContextAndRotateUpsideDown];
  CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
  NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont }];
  CGSize pipSize = [attributedSuit size];
  CGPoint pipOrigin = CGPointMake(
                                  middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                  middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                  );
  [attributedSuit drawAtPoint:pipOrigin];
  if (hoffset) {
    pipOrigin.x += hoffset*2.0*self.bounds.size.width;
    [attributedSuit drawAtPoint:pipOrigin];
  }
  if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
  [self drawPipsWithHorizontalOffset:hoffset
                      verticalOffset:voffset
                          upsideDown:NO];
  if (mirroredVertically) {
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:YES];
  }
}


#pragma mark - Gesture Handling

- (void)tappedCard:(UITapGestureRecognizer *)gesture
{
  if (gesture.state == UIGestureRecognizerStateRecognized) {
    
    self.faceUp = !self.faceUp;
    
    if (!self.faceUp) {
      self.rank += 1;
      if (self.rank >= 14) {
        self.rank = 1;
      }
    }
  }
}

@end
