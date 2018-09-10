//
//  ViewController.m
//  KTVideo
//
//  Created by Ki on 2018/9/3.
//  Copyright © 2018年 Ki. All rights reserved.
//

#import "ViewController.h"
#import "VideoViewController.h"
#import "XLAccountVC.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *roomNameTF;

@end

@implementation ViewController
//进入频道
- (IBAction)joinChannelBtnClick:(id)sender {
    
    NSString * roomNameStr = self.roomNameTF.text;
    if (roomNameStr && roomNameStr.length > 0) {
        VideoViewController * vc = [[VideoViewController alloc]init];
        vc.roomName = roomNameStr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//信令
- (IBAction)xinLingBtnClick:(id)sender {
    XLAccountVC * vc = [[XLAccountVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.roomNameTF resignFirstResponder];
}


@end
