//
//  FLCalendarItemCell.m
//  FlowLayout
//
//  Created by Fuzzie Liu on 15/11/2.
//  Copyright © 2015年 Fuzzie Liu. All rights reserved.
//

#import "FLCalendarItemCell.h"
#import "NSDate+FLCalendar.h"

#define Width self.bounds.size.width
#define Margin 7.0f
#define ShadowMargin 5.5f
#define CurrentMonth 0xff9966
#define OtherMonth 0xffff66

@implementation FLCalendarItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景View
        self.backView = [[UIView alloc] init];
        [self addSubview:_backView];
        self.backView.layer.cornerRadius = (Width - Margin * 2) / 2;
        
        // 日期label
        self.dateLabel = [[UILabel alloc] init];
        [self addSubview:_dateLabel];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.backgroundColor = [UIColor clearColor];
        
        // 把contentView调成灰色, 显示灰色的圈
        self.contentView.hidden = YES;
        self.contentView.backgroundColor = [UIColor grayColor];
        self.contentView.layer.cornerRadius = (Width - ShadowMargin * 2) / 2;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.frame = CGRectMake(Margin, Margin, Width - Margin * 2, Width - Margin * 2);
    self.dateLabel.frame = self.contentView.bounds;
    self.contentView.frame = CGRectMake(ShadowMargin, ShadowMargin, Width - ShadowMargin * 2, Width -ShadowMargin * 2);
}

#pragma mark 根据当月日历和indexPath加载cell上的日期的方法
- (void)setUpDateLabelWithIndexPath:(NSIndexPath *)indexPath
{
    // 日历上第一天的星期, 前后三个月的总天数
    NSInteger firstWeekDay = [self.calendarDate weekdayOfFirsDayInMonth];
    NSInteger totalDays = [self.calendarDate numbersOfDaysInMonth];
    NSInteger previousMonthDays = [[self.calendarDate previousMonthDate] numbersOfDaysInMonth];
    NSInteger day = 0;
    
    // 获得三个月的components
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.calendarDate];
    NSDateComponents *previousComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[self.calendarDate previousMonthDate]];
    NSDateComponents *nextComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[self.calendarDate nextMonthDate]];
    
    if (firstWeekDay <= indexPath.item + 1 && indexPath.item <= firstWeekDay + totalDays - 2) {
        // 当月日期
        day = indexPath.item - firstWeekDay + 2;
        self.backView.backgroundColor = UIColorFromRGB(CurrentMonth);
        [currentComponents setDay:day];
        self.cellComponents = currentComponents;
        self.cellDate = [calendar dateFromComponents:currentComponents];
    }else if (indexPath.item < firstWeekDay){
        // 上个月日期
        day = previousMonthDays + indexPath.item - firstWeekDay + 2;
        self.backView.backgroundColor = UIColorFromRGB(OtherMonth);
        [previousComponents setDay:day];
        self.cellComponents = previousComponents;
        self.cellDate = [calendar dateFromComponents:previousComponents];
    }else{
        // 下月日期
        day = indexPath.item - firstWeekDay + 2 - totalDays;
        self.backView.backgroundColor = UIColorFromRGB(OtherMonth);
        [nextComponents setDay:day];
        self.cellComponents = nextComponents;
        self.cellDate = [calendar dateFromComponents:nextComponents];
    }
    self.dateLabel.text = [NSString stringWithFormat:@"%ld", day];
}

@end
