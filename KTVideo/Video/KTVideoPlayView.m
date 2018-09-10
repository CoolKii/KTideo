//
//  KTVideoPlayView.m
//  WELiveSDK_KT
//
//  Created by Ki on 2018/9/4.
//  Copyright © 2018年 Ki. All rights reserved.
//

#import "KTVideoPlayView.h"
#import "VideoSession.h"

//KT
#define AppId @"2018bebbc1e74813825b2e6264515a14"

@interface KTVideoPlayView ()<AgoraRtcEngineDelegate>

@property (nonatomic,strong)AgoraRtcEngineKit * agoraKit;
@property (strong, nonatomic) NSMutableArray <VideoSession *> *videoSessions;
@property (strong, nonatomic) VideoSession * theSession;

@end

@implementation KTVideoPlayView

-(void)setRoomName:(NSString *)roomName{
    _roomName = roomName;
    [self initAgoraKit];
}


//该 uid对应的 videoSession
- (VideoSession *)videoSessionOfUid:(NSUInteger)uid{
    VideoSession *fetchedSession = [self fetchSessionOfUid:uid];
    if (fetchedSession){
        return fetchedSession;
    } else {
        VideoSession *newSession = [[VideoSession alloc] initWithUid:uid];
        [self.videoSessions addObject:newSession];
        [self updateInterfaceWithAnimation:YES];
        return newSession;
    }
}
//查找是否存在该 videoSession
- (VideoSession *)fetchSessionOfUid:(NSUInteger)uid {
    for (VideoSession *session in self.videoSessions) {
        if (session.uid == uid) {
            return session;
        }
    }
    return nil;
}

#pragma mark - 播放SDK初始化
//准备阶段
- (void)initAgoraKit{
    //创建一个 AgoraRtcEngine 实例
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:AppId delegate:self];
    //设置频道模式
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit enableDualStreamMode:YES];
    //设置用户角色
    [self.agoraKit setClientRole:2];//观众
    
    //设置视频编码属性 （分辨率、帧率、码率、视频方向）
    AgoraVideoEncoderConfiguration *configuration = [[AgoraVideoEncoderConfiguration alloc]
                                                     initWithSize:AgoraVideoDimension120x120 frameRate:AgoraVideoFrameRateFps15 bitrate:400 orientationMode:AgoraVideoOutputOrientationModeFixedLandscape];
    [self.agoraKit setVideoEncoderConfiguration:configuration];
   
    //打开视频模式
    [self.agoraKit enableVideo];
    //并 禁用 本地视频
    [self.agoraKit enableLocalVideo:NO];
    
    int code = [self.agoraKit joinChannelByToken:nil channelId:self.roomName info:nil uid:0 joinSuccess:nil];
    if (code == 0) {
        //
        NSLog(@"Join channel success: %d",code);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Join channel failed: %d",code);
        });
    }
}

#pragma mark - set VideoSessions Or fullVideoSission
//set VideoSessions
- (void)setVideoSessions:(NSMutableArray<VideoSession *> *)videoSessions {
    _videoSessions = videoSessions;
    if (self) {
        [self updateInterfaceWithAnimation:YES];
    }
}

#pragma mark - 更新界面
- (void)updateInterfaceWithAnimation:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateInterface];
            [self layoutIfNeeded];
        }];
    } else {
        [self updateInterface];
    }
}

- (void)updateInterface{
    NSArray * displaySessions;
    if (self.videoSessions.count) {
        displaySessions = [self.videoSessions subarrayWithRange:NSMakeRange(1, self.videoSessions.count - 1)];
    } else {
        displaySessions = [self.videoSessions copy];
    }
    //设置远端视频大小流（全屏 用大流 & 非全屏用小流）
     [self.agoraKit setRemoteVideoStream:self.theSession.uid type:AgoraVideoStreamTypeHigh];
}


#pragma mark - <AgoraRtcEngineDelegate>
//主播加入回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    VideoSession *userSession = [self videoSessionOfUid:uid];
    userSession.hostingView.frame = self.bounds;
    [self addSubview:userSession.hostingView];
    [self.agoraKit setupRemoteVideo:userSession.canvas];
}

//本地首帧视频显示回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed {}

//远端首帧视频显示回调
-(void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{}

//主播离线回调 （删除对应的videoSission）
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    VideoSession * deleteSession;
    for (VideoSession * session in self.videoSessions) {
        if (session.uid == uid) {
            deleteSession = session;
        }
    }
    if (deleteSession) {
        [self.videoSessions removeObject:deleteSession];
        [deleteSession.hostingView removeFromSuperview];
        [self updateInterfaceWithAnimation:YES];
    }
}


#pragma mark - 退出直播
-(void)dealloc{
    [self.agoraKit leaveChannel:nil];
}


@end
