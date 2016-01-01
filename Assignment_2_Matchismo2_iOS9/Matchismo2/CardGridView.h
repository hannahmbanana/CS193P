//
//  CardGridView.h
//  Matchismo2
//
//  Created by Hannah Troisi on 12/30/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardGridView : UIView

@property (strong, nonatomic, readonly) NSArray *cardButtonArray;

- (instancetype) initWithColumns:(NSUInteger)columnCount
                            rows:(NSUInteger)rowCount;

@end
