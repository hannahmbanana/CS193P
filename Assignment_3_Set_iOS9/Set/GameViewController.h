//
//  GameViewController.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonGridView.h"
#import "MatchingGame.h"
#import "Deck.h"

// ABSTRACT CLASS
@interface GameViewController : UIViewController 

@property (nonatomic, strong, readwrite) MatchingGame              *game;
@property (nonatomic, strong, readwrite) ButtonGridView            *buttonGridView;
@property (nonatomic, strong, readwrite) UILabel                   *scoreLabel;
@property (nonatomic, strong, readwrite) UILabel                   *gameCommentaryLabel;
@property (nonatomic, strong, readwrite) NSMutableAttributedString *gameCommentaryHistory;
@property (nonatomic, strong, readwrite) UIButton                  *dealButton;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithColumnCount:(NSUInteger)numCols rowCount:(NSUInteger)numRows NS_DESIGNATED_INITIALIZER;
- (void) updateUI;

+ (Class)gameClass;                                                     // SUBCLASS MUST IMPLEMENT
- (Deck *)createDeck;                                                   // SUBCLASS MUST IMPLEMENT
- (NSAttributedString *)attributedTitleForCard:(Card *)card
                                      override:(BOOL)shouldOverride; // SUBCLASS MUST IMPLEMENT
- (UIImage *)backgroundImageForCardAtIndex:(NSUInteger)index;           // SUBCLASS MUST IMPLEMENT
- (BOOL)shadowForCardAtIndex:(NSUInteger)index;                         // SUBCLASS MUST IMPLEMENT

@end
