//
//  GameViewController.h
//  Set
//
//  Created by Hannah Troisi on 1/1/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchingGame.h"

// ABSTRACT CLASS
@interface GameViewController : UIViewController 

@property (nonatomic, strong, readwrite) MatchingGame       *game;
@property (nonatomic, strong, readwrite) UICollectionView   *collectionView;
@property (nonatomic, strong, readwrite) UIToolbar          *toolBar;

+ (Class)gameClass;                            // SUBCLASS MUST IMPLEMENT
+ (Class)deckClass;                            // SUBCLASS MUST IMPLEMENT
+ (Class)cardViewClass;                        // SUBCLASS MUST IMPLEMENT
+ (NSUInteger)numCardsInMatch;                 // SUBCLASS MUST IMPLEMENT
+ (NSUInteger)numCardsInGame;                  // SUBCLASS MUST IMPLEMENT

- (void)touchDealButton;
- (void)touchCardButtonAtIndex:(NSUInteger)cardButtonIndex;


@end
