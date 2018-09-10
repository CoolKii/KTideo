//
//  MessageModel.h
//  KTVideo
//
//  Created by Ki on 2018/9/10.
//  Copyright © 2018年 Ki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,copy)NSString * channelID;
@property (nonatomic,copy)NSString * account;
@property (nonatomic,assign)uint32_t uid;
@property (nonatomic,copy)NSString * msg;

@end
