//
//  MsgLeftCell.m
//  KTVideo
//
//  Created by Ki on 2018/9/10.
//  Copyright © 2018年 Ki. All rights reserved.
//

#import "MsgLeftCell.h"
#import "MessageModel.h"

@interface MsgLeftCell ()

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;


@end

@implementation MsgLeftCell

-(void)setMsgModel:(MessageModel *)msgModel{
    _msgModel = msgModel;
    self.msgLabel.text = msgModel.msg;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
