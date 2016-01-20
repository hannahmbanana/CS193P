//
//  ScoreTableViewController.h
//  Set
//
//  Created by Hannah Troisi on 1/9/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

/* FYI - once a single nullability type specifier has been applied to a type, Xcode generates warnings for all other
 types that do not have nullability type applied. Can use NS_ASSUME_NONNULL_{BEGIN,END} to suppress woarnings. */
NS_ASSUME_NONNULL_BEGIN

@interface ScoreTableViewController : UITableViewController

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
