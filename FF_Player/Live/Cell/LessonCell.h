//
//  LessonCell.h
//  FF_ScrennSwitch
//
//  Created by fanxiaobin on 2017/12/5.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;

@end
