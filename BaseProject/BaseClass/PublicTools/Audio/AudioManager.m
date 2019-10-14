//
//  AudioManager.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/5.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "AudioManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioManager () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end



@implementation AudioManager

#pragma mark - Getter

- (AVAudioSession *)session {
    if (!_session) {
        AVAudioSession *session = [AVAudioSession sharedInstance];

        // AVAudioSessionCategorySoloAmbient是系统默认的category
        NSError *setCategoryError = nil;
        BOOL isSuccess = [session setCategory:AVAudioSessionCategorySoloAmbient
                                  withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDuckOthers
                                        error:&setCategoryError];
        if (!isSuccess) {
            NSLog(@"%@", setCategoryError.localizedDescription);
            //这里可以读取setCategoryError.localizedDescription查看错误原因
        }
        // 激活AVAudioSession
        [session setActive:YES error:nil];
        _session = session;
    }
    return _session;
}



#pragma mark - Initializer

+ (AudioManager *)shared {
    static AudioManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[AudioManager alloc] init];
        }
    });
    return instance;

//    static __weak AudioManager *instance;
//    AudioManager *strongInstance = instance;
//    @synchronized(self) {
//        if (strongInstance == nil) {
//            strongInstance = [[[self class] alloc] init];
//            instance = strongInstance;
//        }
//    }
//    return strongInstance;
}



#pragma mark - System Audio Service

- (void)playSoundWithFilename:(NSString *)filename {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    //1.获得系统声音ID
    SystemSoundID soundID = 0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);

    //2.播放音频
    //播放音效
    AudioServicesPlaySystemSound(soundID);
    //播放音效并震动
    //    AudioServicesPlayAlertSound(soundID);

    //3.销毁声音
    AudioServicesDisposeSystemSoundID(soundID);
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    NSLog(@"播放完成...");
}



#pragma mark - AVAudio

- (void)playSongByAVAudioWithFilename:(NSString *)filename {
    AVAudioSession *session = [AVAudioSession sharedInstance];

    // AVAudioSessionCategorySoloAmbient是系统默认的category
    NSError *setCategoryError = nil;
    BOOL isSuccess = [session setCategory:AVAudioSessionCategorySoloAmbient
                              withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                    error:&setCategoryError];
    if (!isSuccess) {
        NSLog(@"%@", setCategoryError.localizedDescription);
        //这里可以读取setCategoryError.localizedDescription查看错误原因
    }
    // 激活AVAudioSession
    [session setActive:YES error:nil];


    NSString *audioFile = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    __unused NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n音频文件持续时间:%gs", (long)_audioPlayer.numberOfChannels, _audioPlayer.duration];
//    NSLog(@"%@",msg);

    if (_audioPlayer) {
        // 注册打断通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:session];
        _audioPlayer.delegate = self;
        if ([_audioPlayer prepareToPlay]) {
            __unused BOOL playStart = [_audioPlayer play];
//            NSLog(@"%@", playStart ? @"audioPlayer可以播放": @"audioPlayer播放失败");
        }

    }
}

/// 停止audioPlayer播放
- (void)stopAudioPlay {
    [_audioPlayer stop];
}



#pragma mark - Private Func

/**
 完成播放， 但是在打断播放和暂停、停止不会调用
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [_audioPlayer stop];
//        NSLog(@"audioPlayer播放结束");
    }
}

/**
 播放过程中解码错误时会调用
 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"audioPlayer解码错误：%@", error.userInfo);
}



#pragma mark -

- (void)AVAudioSessionInterruptionNotification:(NSNotification *)noti {
    AVAudioSessionInterruptionType type = [noti.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    switch (type) {
        case AVAudioSessionInterruptionTypeBegan:
            NSLog(@"audioSession 打断开始");
            [_audioPlayer stop];
            break;

        case AVAudioSessionInterruptionTypeEnded:
            NSLog(@"audioSession 打断结束");
            break;

        default:
            break;
    }
}


#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
}

@end
