//
//  BRYSoundEffectPlayer.h
//  BRYSoundEffectPlayer
//
//  Created by Bryan Irace on 12/21/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

@import Foundation;
@import UIKit;
@import AudioToolbox;

/**
 Convenience wrapper around some of Apple's Audio Service functions used for playing sound effects. An instance of `BRYSoundEffectPlayer` will cache sounds in memory until a low memory warning occurs, or if `playsSoundsConcurrently` is set to `NO` and a sound that is already being played must be disposed of in order to stop it.
 
 If your needs are more advanced, you probably want to use `AVAudioPlayer` instead.
 */
@interface BRYSoundEffectPlayer : NSObject

/**
 `NO` by default. When set to `YES`, sounds will play simultaneously. When set to `NO`, a sound that is already being played of will be disposed of and removed from the in-memory cache in order to play another sound (this is the only way to stop a sound being played by `AudioToolbox` functions).
 */
@property (nonatomic) BOOL playsSoundsConcurrently;

+ (instancetype)sharedInstance;

- (void)playSound:(NSString *)filePath;

@end
