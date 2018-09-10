//
//  VideoViewController.m
//  KTVideo
//
//  Created by Ki on 2018/9/4.
//  Copyright © 2018年 Ki. All rights reserved.
//

#import "VideoViewController.h"
#import "KTVideoPlayView.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KTVideoPlayView * view = [[KTVideoPlayView alloc] init];
    view.backgroundColor = UIColor.lightGrayColor;
    view.frame = CGRectMake(0, 65, ScreenW, 9 * (ScreenW / 16) );
    view.roomName = self.roomName;
    [self.view addSubview:view];
    
}












@end
