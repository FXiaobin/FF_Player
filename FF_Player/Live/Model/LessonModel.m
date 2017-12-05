//
//  LessonModel.m
//  FF_ScrennSwitch
//
//  Created by fanxiaobin on 2017/12/5.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "LessonModel.h"

@implementation LessonModel

+ (LessonModel *)makeModelWithDic:(NSDictionary *)dic{
    LessonModel *model = [[LessonModel alloc] init];
    model.creat_time = dic[@"creat_time"];
    model.end_time = dic[@"end_time"];
    model.head_img = dic[@"head_img"];
    model.lesson_name = dic[@"lesson_name"];
    model.lesson_pic = dic[@"lesson_pic"];
    model.live_date = dic[@"live_date"];
    model.profile = dic[@"profile"];
    model.start_time = dic[@"start_time"];
    model.username = dic[@"username"];
    model.video_url = dic[@"video_url"];
    
    
    return model;
}


@end
