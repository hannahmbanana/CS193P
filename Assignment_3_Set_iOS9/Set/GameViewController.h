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

@interface GameViewController : UIViewController 

@property (nonatomic, strong, readwrite) MatchingGame              *game;
@property (nonatomic, strong, readwrite) ButtonGridView            *buttonGridView;
@property (nonatomic, strong, readwrite) UILabel                   *scoreLabel;
@property (nonatomic, strong, readwrite) UILabel                   *gameCommentaryLabel;
@property (nonatomic, strong, readwrite) NSMutableAttributedString *gameCommentaryHistory;
@property (nonatomic, strong, readwrite) UIButton                  *dealButton;

- (void)touchDealButton;
- (void)touchCardButton:(UIButton *)sender;
- (UIImage *)backgroundImageForDealButton;

// SUBCLASS MUST IMPLEMENT
- (void) updateUI;

// SUBCLASS MUST IMPLEMENT
- (Deck *)createDeck;

+ (Class)gameClass;

@end
