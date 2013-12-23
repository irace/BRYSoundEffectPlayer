//
//  BRYSoundEffectPlayer.m
//  BRYSoundEffectPlayer
//
//  Created by Bryan Irace on 12/21/13.
//  Copyright (c) 2013 Bryan Irace. All rights reserved.
//

#import "BRYSoundEffectPlayer.h"

static SystemSoundID const SoundNotFound = 0;

@interface BRYSoundEffectPlayer()

@property (nonatomic) NSMutableDictionary *filePathsToSoundIDs;
@property (nonatomic) NSString *currentSoundFilePath;

@end

@implementation BRYSoundEffectPlayer

+ (instancetype)sharedInstance {
    static BRYSoundEffectPlayer *player;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[BRYSoundEffectPlayer alloc] init];
    });
    
    return player;
}

#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        _filePathsToSoundIDs = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - BRYSoundEffectPlayer

- (void)playSound:(NSString *)filePath {
    NSParameterAssert(filePath != nil);
    
    if (!filePath) {
        return;
    }
    
    if (!self.playsSoundsConcurrently && self.currentSoundFilePath) {
        BRYDisposeOfSound([self soundIDForFilePath:self.currentSoundFilePath]);
        
        [self.filePathsToSoundIDs removeObjectForKey:self.currentSoundFilePath];
    }
    
    self.currentSoundFilePath = filePath;
    
    SystemSoundID soundID = [self soundIDForFilePath:filePath];
    
    if (soundID == SoundNotFound) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:filePath], &soundID);
        self.filePathsToSoundIDs[filePath] = @(soundID);
    }
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, BRYSoundCompletionCallback, (__bridge void *)(self));
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark - Notifications

- (void)clearCache {
    for (NSString *filePath in [self.filePathsToSoundIDs allKeys]) {
        BRYDisposeOfSound([self soundIDForFilePath:filePath]);
    }
    
    [self.filePathsToSoundIDs removeAllObjects];
    
    self.currentSoundFilePath = nil;
}

#pragma mark - Private

- (SystemSoundID)soundIDForFilePath:(NSString *)filePath {
    return [self.filePathsToSoundIDs[filePath] intValue];
}

static void BRYDisposeOfSound(SystemSoundID soundID) {
    AudioServicesRemoveSystemSoundCompletion(soundID);
    AudioServicesDisposeSystemSoundID(soundID);
}

static void BRYSoundCompletionCallback(SystemSoundID soundID, void *object) {
    BRYSoundEffectPlayer *soundPlayer = (__bridge BRYSoundEffectPlayer *)object;
    soundPlayer.currentSoundFilePath = nil;
    
    AudioServicesRemoveSystemSoundCompletion(soundID);
}

@end