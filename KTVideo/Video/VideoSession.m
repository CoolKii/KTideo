//
//  VideoSession.m
//  OpenLive
//
//  Created by GongYuhua on 2016/9/12.
//  Copyright © 2016年 Agora. All rights reserved.
//

#import "VideoSession.h"

@implementation VideoSession
- (instancetype)initWithUid:(NSUInteger)uid {
    if (self = [super init]) {
        self.uid = uid;
        
        self.hostingView = [[UIView alloc] init];
        self.hostingView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.canvas = [[AgoraRtcVideoCanvas alloc] init];
        self.canvas.uid = uid;
        self.canvas.view = self.hostingView;
        self.canvas.renderMode = AgoraVideoRenderModeHidden;
        /*
         AgoraVideoRenderModeHidden (1)：视频尺寸等比缩放。优先保证视窗被填满。因视频尺寸与显示视窗尺寸不一致而多出的视频将被截掉。
         AgoraVideoRenderModeFit (2)：视频尺寸等比缩放。优先保证视频内容全部显示。因视频尺寸与显示视窗尺寸不一致造成的视窗未被填满的区域填充黑色。
         */
    }
    return self;
}

+ (instancetype)localSession {
    return [[VideoSession alloc] initWithUid:0];
}


@end
