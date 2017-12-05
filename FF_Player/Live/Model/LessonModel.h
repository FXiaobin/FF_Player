//
//  LessonModel.h
//  FF_ScrennSwitch
//
//  Created by fanxiaobin on 2017/12/5.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonModel : NSObject

@property  (nonatomic,strong) NSString *creat_time;
@property  (nonatomic,strong) NSString *end_time;
@property  (nonatomic,strong) NSString *head_img;
@property  (nonatomic,strong) NSString *lesson_name;
@property  (nonatomic,strong) NSString *lesson_pic;
@property  (nonatomic,strong) NSString *live_date;

@property  (nonatomic,strong) NSString *profile;
@property  (nonatomic,strong) NSString *start_time;
@property  (nonatomic,strong) NSString *username;
@property  (nonatomic,strong) NSString *video_url;

+ (LessonModel *)makeModelWithDic:(NSDictionary *)dic;


@end
