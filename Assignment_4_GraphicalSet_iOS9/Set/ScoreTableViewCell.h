//
//  ScoreTableViewCell.h
//  Set
//
//  Created by Hannah Troisi on 1/10/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

/* FYI - once a single nullability type specifier has been applied to a type, Xcode generates warnings for all other 
   types that do not have nullability type applied. Can use NS_ASSUME_NONNULL_{BEGIN,END} to suppress woarnings. */
NS_ASSUME_NONNULL_BEGIN

@interface ScoreTableViewCell : UITableViewCell

- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END