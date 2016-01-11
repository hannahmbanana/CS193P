//
//  ScoreTableViewCell.h
//  Set
//
//  Created by Hannah Troisi on 1/10/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>

// Macro used to supress compiler warnings by removing the explicit nonnull specifier. Once a single nullability type
// specifier has been applied to a type, Xcode generates warnings for all other types that do not have nullability type
// specifiers applied.
NS_ASSUME_NONNULL_BEGIN

@interface ScoreTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END