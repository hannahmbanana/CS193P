//
//  ButtonGridView.h
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/18/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonGridView : UIView

@property (strong, nonatomic, readonly) NSArray *cardButtonArray;

- (instancetype) initWithColumns:(NSUInteger)columnCount
                            rows:(NSUInteger)rowCount;
@end
