//
//  SetCardView.m
//  Set
//
//  Created by Hannah Troisi on 1/10/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "SetCardView.h"
#import "SetCard.h"

@implementation SetCardView


#pragma mark - Class Methods

+ (NSArray *)setCardColors
{
  return @[@"pink", @"purple", @"green"];
}

+ (NSArray *)setCardShapes
{
  return @[@"diamond", @"oval", @"squiggle"];
}

+ (NSArray *)setCardFills
{
  return @[@"solid", @"unfilled", @"striped"];
}

+ (NSArray *)setCardNumbers
{
  return @[@1,@2,@3];
}

+ (UIColor *)uIColorForSetColorString:(NSString *)string
{
  UIColor *color;
  
  if ([string isEqualToString:@"pink"]) {
    
    color = [UIColor colorWithRed:252.0f/255.0f green:004.0f/255.0f blue:118.0f/255.0f alpha:1.0f];
    
  } else if ([string isEqualToString:@"purple"]) {
    
    color = [UIColor colorWithRed:085.0f/255.0f green:070.0f/255.0f blue:151.0f/255.0f alpha:1.0f];
    
  } else if ([string isEqualToString:@"green"]) {
    
    color = [UIColor colorWithRed:085.0f/255.0f green:218.0f/255.0f blue:089.0f/255.0f alpha:1.0f];
  }
  
  return color;
}


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame card:(SetCard *)card
{
  self = [super initWithFrame:frame card:card];
  
  if (self) {
    
    // card properties
    [self updateCardProperties:card];
  }
  
  return self;
}


#pragma mark - Instance Methods

- (void)updateCardProperties:(SetCard *)card
{
  [super updateCardProperties:card];

  // card properties
  self.number = card.number;
  self.color = card.color;
  self.shape = card.shape;
  self.fill = card.shade;
  
  self.userInteractionEnabled = card.isMatched ? NO : YES;
  self.alpha = card.isMatched ? 0.4 : 1.0;
  
  // add shadow
  if (card.isChosen && !card.isMatched) {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(4.0,4.0);
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius = 0.0;
  } else {
    self.layer.shadowOffset = CGSizeZero;
  }
}

#pragma mark - Properties

- (void)setShape:(NSString *)shape
{
  if ( [[[self class] setCardShapes] containsObject:shape] ) {
    _shape = shape;
    [self setNeedsDisplay];
  }
}

- (void)setColor:(NSString *)color
{
  if ( [[[self class] setCardColors] containsObject:color] ) {
    _color = color;
    [self setNeedsDisplay];
  }
}

- (void)setFill:(NSString *)fill
{
  if ( [[[self class] setCardFills] containsObject:fill] ) {
    _fill = fill;
    [self setNeedsDisplay];
  }
}

- (void)setNumber:(NSUInteger)number
{
  if ( [[[self class] setCardNumbers] containsObject:[NSNumber numberWithInteger:number]] ) {
    _number = number;
    [self setNeedsDisplay];
  }
}


#pragma mark - Layout

#define CARD_WIDTH_TO_SHAPE_WIDTH_RATIO 0.65
#define SHAPE_ASPECT_RATIO 0.43

- (CGSize)preferredShapeSizeForCardWidth:(CGFloat)width;
{
  CGFloat shapeWidth  = roundf(width * CARD_WIDTH_TO_SHAPE_WIDTH_RATIO);
  CGFloat shapeHeight = roundf(shapeWidth * SHAPE_ASPECT_RATIO);
  
  return CGSizeMake( shapeWidth, shapeHeight);
}

#define CARD_WIDTH_TO_SHAPE_BUFFER_RATIO 0.15

- (CGFloat)preferredShapeOffsetForCardWidth:(CGFloat)width;
{
  return roundf(width * CARD_WIDTH_TO_SHAPE_BUFFER_RATIO);
}

#define CARD_WIDTH_TO_STRIP_WIDTH 19

- (CGFloat)preferredStripeFillWidthForCardWidth:(CGFloat)width;
{
  return roundf(width / CARD_WIDTH_TO_STRIP_WIDTH);
}


#pragma mark - Drawing

#define STROKE_LINE_WIDTH_SCALE 0.05

- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
  // calculate individual shape size & inter-shape buffer (for n > 1 shapes)
  CGSize  shapeSize   = [self preferredShapeSizeForCardWidth:self.bounds.size.width];
  CGFloat shapeBuffer = [self preferredShapeOffsetForCardWidth:self.bounds.size.width];
  
  // calculate height of shape block
  CGFloat shapeBlockHeight = self.number * shapeSize.height + (self.number - 1) * shapeBuffer;
  CGPoint shapeBlockOrigin = CGPointMake( roundf((self.bounds.size.width - shapeSize.width) / 2),
                                          roundf((self.bounds.size.height - shapeBlockHeight) / 2));
  
  // loop through correct number of shapes
  for (int i = 0; i < self.number; i++) {
    
    // set shape CGRect
    CGRect shapeRect = (CGRect) {shapeBlockOrigin, shapeSize};
    
    // draw shape
    if ([self.shape isEqualToString:@"oval"]) {
      
      [self drawOvalWithRect:shapeRect];
      
    } else if ([self.shape isEqualToString:@"squiggle"]) {
      
      [self drawSquiggleWithRect:shapeRect];
      
    } else if ([self.shape isEqualToString:@"diamond"]) {
      
      [self drawDiamondWithRect:shapeRect];
    }
    
    // setup next shape's origin
    shapeBlockOrigin.y += shapeSize.height + shapeBuffer;
  }
}

- (void)drawOvalWithRect:(CGRect)rect
{
  // create oval shape path
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:roundf(rect.size.height/2)];
  
  // draw shape path with correct fill
  [self drawShapeFillWithPath:path WithWidth:roundf(rect.size.height * STROKE_LINE_WIDTH_SCALE)];
}

- (void)drawDiamondWithRect:(CGRect)rect
{
  // create diamond shape path
  UIBezierPath *path = [[UIBezierPath alloc] init];
  
  // left point
  CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + roundf(rect.size.height / 2));
  [path moveToPoint:startPoint];
  
  // bottom point
  startPoint.x += roundf(rect.size.width / 2);
  startPoint.y += roundf(rect.size.height / 2);
  [path addLineToPoint:startPoint];
  
  // right point
  startPoint.x += roundf(rect.size.width / 2);
  startPoint.y -= roundf(rect.size.height / 2);
  [path addLineToPoint:startPoint];
  
  // top point
  startPoint.x -= roundf(rect.size.width / 2);
  startPoint.y -= roundf(rect.size.height / 2);
  [path addLineToPoint:startPoint];
  
  [path closePath];
  
  // draw shape path with correct fill
  [self drawShapeFillWithPath:path WithWidth:roundf(rect.size.height * STROKE_LINE_WIDTH_SCALE)];
}

- (void)drawSquiggleWithRect:(CGRect)rect
{
  // Bezier curve control points aren't necessarily in the path, so need to widen rect to get full coverage of space
  CGPoint origin = CGPointMake(rect.origin.x - floorf(rect.size.width * 0.04), rect.origin.y - floorf(rect.size.height * 0.2));
  CGFloat width  = roundf(rect.size.width * 1.1);
  CGFloat height = roundf(rect.size.height * 1.36);
  
  // draw the squiggle
  UIBezierPath *path = [[UIBezierPath alloc] init];
  
  [path moveToPoint: CGPointMake(origin.x + floorf(width * 0.93),    origin.y + height * 0.23) ];
  
  [path addCurveToPoint: CGPointMake(origin.x + floorf(width * 0.56),   origin.y + floorf(height * 0.82))
          controlPoint1: CGPointMake(origin.x + floorf(width * 1.0),    origin.y + floorf(height * 0.56))
          controlPoint2: CGPointMake(origin.x + floorf(width * 0.8),    origin.y + floorf(height * 0.92))];
  
  [path addCurveToPoint: CGPointMake(origin.x + floorf(width * 0.24),   origin.y + floorf(height * 0.8))
          controlPoint1: CGPointMake(origin.x + floorf(width * 0.36),   origin.y + floorf(height * 0.77))
          controlPoint2: CGPointMake(origin.x + floorf(width * 0.38),   origin.y + floorf(height * 0.64))];
  
  [path addCurveToPoint: CGPointMake(origin.x + floorf(width * 0.04),   origin.y + floorf(height * 0.6))
          controlPoint1: CGPointMake(origin.x + floorf(width * 0.09),   origin.y + floorf(height * 1.0))
          controlPoint2: CGPointMake(origin.x + floorf(width * 0.04),   origin.y + floorf(height * 0.88))];
  
  [path addCurveToPoint: CGPointMake(origin.x + floorf(width * 0.32),   origin.y + floorf(height * 0.18))
          controlPoint1: CGPointMake(origin.x + floorf(width * 0.04),   origin.y + floorf(height * 0.33))
          controlPoint2: CGPointMake(origin.x + floorf(width * 0.17),   origin.y + floorf(height * 0.15))];
  
  [path addCurveToPoint: CGPointMake(origin.x + floorf(width * 0.79),   origin.y + floorf(height * 0.21))
          controlPoint1: CGPointMake(origin.x + floorf(width * 0.53),   origin.y + floorf(height * 0.23))
          controlPoint2: CGPointMake(origin.x + floorf(width * 0.55),   origin.y + floorf(height * 0.47))];
  
  [path addCurveToPoint: CGPointMake(origin.x + floorf(width * 0.93),   origin.y + floorf(height * 0.23))
          controlPoint1: CGPointMake(origin.x + floorf(width * 0.85),   origin.y + floorf(height * 0.15))
          controlPoint2: CGPointMake(origin.x + floorf(width * 0.9),    origin.y + floorf(height * 0.11))];
  
  // draw shape path with correct fill
  [self drawShapeFillWithPath:path WithWidth:roundf(rect.size.height * STROKE_LINE_WIDTH_SCALE)];
}

- (void)drawShapeFillWithPath:(UIBezierPath *)path WithWidth:(CGFloat)width
{
  // set line width
  path.lineWidth = width;
  
  // set color
  UIColor *color = [[self class] uIColorForSetColorString:self.color];
  [color set];
  
  // draw outline (for unfilled, solid & striped cases)
  [path stroke];
  
  if ([self.fill isEqualToString:@"solid"]) {
    
    [path fill];
  
  } else if ([self.fill isEqualToString:@"striped"]) {
    
    // Code adapted from: https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_patterns/dq_patterns.html#//apple_ref/doc/uid/TP30001066-CH206-BBCJAJEC
    
    // save the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat stripeWidth = [self preferredStripeFillWidthForCardWidth:self.bounds.size.width];
//    CGContextSetLineWidth(context, ceilf(self.bounds.size.width * ?));
    
    // declare an array to hold a color value and sets the value (which will be in RGB color space) to self.color
    const double *colorComponents = CGColorGetComponents(color.CGColor);
    
    // declare and fill a callbacks structure, passing 0 as the version, a pointer to a drawing callback function,
    // and NULL for release info
    static const CGPatternCallbacks callbacks = {0, &StripedPatternStencil, NULL};
    
    // create an RGB device color space (required to draw a pattern to a display)
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB ();
    
    // create a pattern color space object from the RGB device color space
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern (baseSpace);
    
    // set the fill color space to the pattern color space object just created
    CGContextSetFillColorSpace (context, patternSpace);
    CGColorSpaceRelease (patternSpace);
    CGColorSpaceRelease (baseSpace);
    
    // create the pattern object with isColored = false (for a stencil)
    CGPatternRef pattern = CGPatternCreate(NULL,
                                           self.bounds,
                                           CGAffineTransformIdentity,
                                           stripeWidth,
                                           1,
                                           kCGPatternTilingConstantSpacing,
                                           false,
                                           &callbacks);
    
    // set the fill pattern, passing the color array above
    CGContextSetFillPattern (context, pattern, colorComponents);
    
    // relase the pattern object
    CGPatternRelease (pattern);
    
    // convert UIBezierPath path to CGPath
    CGPathRef cgPath = CGPathCreateCopy(path.CGPath);

    // add CGPath to context
    CGContextAddPath(context, cgPath);

    // fill the context's path with the pattern object
    CGContextFillPath(context);
    
    // release the CGPath
    CGPathRelease(cgPath);
    
    // restore the saved graphics context
    CGContextRestoreGState(context);
  }
}

void StripedPatternStencil (void *info, CGContextRef myContext)
{
  // draw one unit of the stripe pattern
  CGContextMoveToPoint(myContext, 0, 0);
  CGContextAddLineToPoint(myContext, 1, 1);
  
  // stroke the path
  CGContextStrokePath(myContext);
}

@end
