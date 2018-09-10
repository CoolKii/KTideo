//
//  ChannelChatRoomVC.m
//  KTVideo
//
//  Created by Ki on 2018/9/10.
//  Copyright © 2018年 Ki. All rights reserved.
//

#import "ChannelChatRoomVC.h"
#import <CommonCrypto/CommonDigest.h>
#import "AgoraSigKit.framework/Headers/AgoraSigKit.h"
#import "MsgLeftCell.h"
#import "MsgRightCell.h"
#import "MessageModel.h"

static NSString * appId = @"2018bebbc1e74813825b2e6264515a14";
static NSString * msgLeftCell_ID = @"msgLeftCell_ID";
static NSString * msgRightCell_ID = @"msgRightCell_ID";

@interface ChannelChatRoomVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;

@property (nonatomic,strong)AgoraAPI * agoraSignalKit;
//
@property (nonatomic,assign)uint32_t self_Uid;
@property (nonatomic,copy)NSMutableArray * msgList;
@property (nonatomic,assign)CGFloat labWidth;

@end

@implementation ChannelChatRoomVC

#pragma mark -  // 发送频道消息
- (IBAction)sendBtnClick:(id)sender {
    NSString * sendMsg = self.messageTF.text;
    if (!sendMsg | (sendMsg.length == 0)) {
        NSLog(@"空信息！");
    }else{
        [self.agoraSignalKit messageChannelSend:self.channelID msg:sendMsg msgID:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labWidth = [UIScreen mainScreen].bounds.size.width - 119;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MsgLeftCell class]) bundle:nil] forCellReuseIdentifier:msgLeftCell_ID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MsgRightCell class]) bundle:nil] forCellReuseIdentifier:msgRightCell_ID];
    
     self.agoraSignalKit  = [AgoraAPI getInstanceWithoutMedia:appId];
    //登录 Agora 信令系统
    [self.agoraSignalKit login2:appId account:self.accountID token:@"_no_need_token" uid:0 deviceID:nil retry_time_in_s:60 retry_count:5];
    __weak typeof(*&self) weakSelf = self;
    self.agoraSignalKit.onLoginSuccess = ^(uint32_t uid, int fd) {
        NSLog(@"###登录SDK成功。");
        weakSelf.self_Uid = uid;
    };
    self.agoraSignalKit.onLoginFailed = ^(AgoraEcode ecode) {
        NSLog(@"###登录SDK失败！");
    };
    
    // 加入频道
    [self.agoraSignalKit channelJoin:self.channelID];
    self.agoraSignalKit.onChannelJoined = ^(NSString *channelID) {
        NSLog(@"###进入频道成功。");
    };
    self.agoraSignalKit.onChannelJoinFailed = ^(NSString *channelID, AgoraEcode ecode) {
        NSLog(@"###进入频道失败！");
    };
    
    //发送信息成功回调
    self.agoraSignalKit.onMessageSendSuccess = ^(NSString *messageID) {
        NSLog(@"===发送信息成功。");
    };
    //发送信息失败回调
    self.agoraSignalKit.onMessageSendError = ^(NSString *messageID, AgoraEcode ecode) {
        NSLog(@"===发送信息失败！");
    };
    
    //接收  到频道消息回调
    self.agoraSignalKit.onMessageChannelReceive = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *msg) {
        NSLog(@"===接收信息:%@",msg);
        //
        MessageModel * model = [[MessageModel alloc] init];
        model.uid = uid;
        model.msg = msg;
        model.account = account;
        model.channelID = channelID;
        [weakSelf.msgList addObject:model];
        //
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    };
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出频道
    [self.agoraSignalKit channelLeave:self.channelID];
    // 设置退出频道回调
    self.agoraSignalKit.onChannelLeaved = ^(NSString *channelID, AgoraEcode ecode) {
        NSLog(@"###离开频道！");
    };
    // 退出 Agora 信令系统
    [self.agoraSignalKit logout];
    self.agoraSignalKit.onLogout = ^(AgoraEcode ecode) {
        NSLog(@"###退出SDK！%ld",ecode);
    };
}
//


-(NSMutableArray *)msgList{
    if (!_msgList) {
        _msgList = [NSMutableArray arrayWithCapacity:0];
    }
    return _msgList;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel * model = [self.msgList objectAtIndex:indexPath.row];
    if (model.uid == self.self_Uid) {
        MsgRightCell * cell = [tableView dequeueReusableCellWithIdentifier:msgRightCell_ID];
        cell.backgroundColor = UIColor.clearColor;
        cell.msgModel = model;
        return cell;
    }else{
        MsgLeftCell * cell = [tableView dequeueReusableCellWithIdentifier:msgLeftCell_ID];
        cell.msgModel = model;
        cell.backgroundColor = UIColor.clearColor;
        return cell;
    }
    return [UITableViewCell new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel * model = [self.msgList objectAtIndex:indexPath.row];
    NSString * msg = model.msg;
    CGFloat height = [self heightWithString:msg Font:[UIFont fontWithName:@"PingFangSC-Regular" size:16.0] width:self.labWidth];
    return height + 20;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}

#pragma mark - 求高
- (CGFloat )heightWithString:(NSString *)string Font:(UIFont *)font width:(CGFloat)width{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}


@end







