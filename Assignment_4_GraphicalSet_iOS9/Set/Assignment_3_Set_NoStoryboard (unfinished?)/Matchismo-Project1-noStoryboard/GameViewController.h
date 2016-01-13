//
//  GameViewController.h
//  Matchismo-Project1-noStoryboard
//
//  Created by Hannah Troisi on 10/20/15.
//  Copyright © 2015 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonGridView.h"
#import "MatchingGame.h"
#import "Deck.h"

@interface GameViewController : UIViewController

@property (strong, nonatomic) MatchingGame *game;
@property (strong, nonatomic) ButtonGridView *buttonGridView;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *gameCommentaryLabel;
@property (strong, nonatomic) NSMutableAttributedString *gameCommentaryHistory;
@property (strong, nonatomic) UIButton *dealButton;

- (void)touchDealButton;

- (void)touchCardButton:(UIButton *)sender;

// SUBCLASS MUST IMPLEMENT
- (void) updateUI;

// SUBCLASS MUST IMPLEMENT
- (Deck *)createDeck;

- (UIImage *)backgroundImageForDealButton;

+ (Class)gameClass;

@end
