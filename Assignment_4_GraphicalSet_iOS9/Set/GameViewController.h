//
//  GameViewController.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchingGame.h"
#import "Deck.h"

// ABSTRACT CLASS
@interface GameViewController : UIViewController 

@property (nonatomic, strong, readwrite) MatchingGame              *game;
@property (nonatomic, strong, readwrite) UILabel                   *scoreLabel;
@property (nonatomic, strong, readwrite) UIButton                  *dealButton;
@property (nonatomic, strong, readwrite) UICollectionView          *collectionView;

//- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
//- (instancetype)initWithColumnCount:(NSUInteger)numCols rowCount:(NSUInteger)numRows NS_DESIGNATED_INITIALIZER;

+ (Class)gameClass;                                                                          // SUBCLASS MUST IMPLEMENT
+ (Class)deckClass;                                                                          // SUBCLASS MUST IMPLEMENT
+ (Class)cardViewClass;                                                                      // SUBCLASS MUST IMPLEMENT
+ (NSUInteger)numCardsInMatch;                                                               // SUBCLASS MUST IMPLEMENT
+ (NSDictionary *)attributesDictionary;

//- (NSAttributedString *)attributedTitleForCard:(Card *)card overrideIsChosenCheck:(BOOL)shouldOverride;   // SUBCLASS MUST IMPLEMENT
//- (UIImage *)backgroundImageForCardAtIndex:(NSUInteger)index;                                // SUBCLASS MUST IMPLEMENT
//- (BOOL)shadowForCardAtIndex:(NSUInteger)index;                                              // SUBCLASS MUST IMPLEMENT

- (UIImage *)backgroundImageForDealButton;

- (void)touchDealButton;
- (void)touchCardButtonAtIndex:(NSUInteger)cardButtonIndex;


@end
