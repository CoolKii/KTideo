//
//  XLAccountVC.m
//  KTVideo
//
//  Created by Ki on 2018/9/10.
//  Copyright © 2018年 Ki. All rights reserved.
//

#import "XLAccountVC.h"
#import "ChannelChatRoomVC.h"

@interface XLAccountVC ()

@property (weak, nonatomic) IBOutlet UITextField * accountTF;
@property (weak, nonatomic) IBOutlet UITextField * channelTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation XLAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (IBAction)gotoChannelRoomVC:(id)sender {
    ChannelChatRoomVC * vc = [[ChannelChatRoomVC alloc]init];
    vc.channelID = self.channelTF.text;
    vc.accountID = self.accountTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}













@end
