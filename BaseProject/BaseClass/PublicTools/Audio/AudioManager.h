//
//  AudioManager.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/5.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

+ (AudioManager *)shared;

/// 从工程中根据音效的名字播放短音效
- (void)playSoundWithFilename:(NSString *)filename;

/// 通过AVAudio播放音频
- (void)playSongByAVAudioWithFilename:(NSString *)filename;
/// 停止audioPlayer播放
- (void)stopAudioPlay;

@end
