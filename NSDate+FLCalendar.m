//
//  NSDate+FLCalendar.m
//  FlowLayout
//
//  Created by Fuzzie Liu on 15/11/2.
//  Copyright © 2015年 Fuzzie Liu. All rights reserved.
//

#import "NSDate+FLCalendar.h"

@implementation NSDate (FLCalendar)

// 获取当月第一天是星期几
- (NSInteger)weekdayOfFirsDayInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 设定星期日为每周的第一天
    [calendar setFirstWeekday:1];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    // 取得当前月份后, 将components设定为每月的第一天
    [components setDay:1];
    // 获得当月第一天的date(格林威治时间)
    NSDate *firstDate = [calendar dateFromComponents:components];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDate];
    return firstComponents.weekday;
}

// 当月的总天数
- (NSInteger)numbersOfDaysInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

// 上个月
- (NSDate *)previousMonthDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *previousMonth = [calendar dateByAddingComponents:components toDate:self options:NSCalendarMatchStrictly];
    return previousMonth;
}

// 下个月
- (NSDate *)nextMonthDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *nextMonth = [calendar dateByAddingComponents:components toDate:self options:NSCalendarMatchStrictly];
    return nextMonth;
}

// 有bug, 有时候下面会多一行
- (NSInteger)weeksInMonth
{
    NSInteger totalDays = [self numbersOfDaysInMonth];
    NSInteger firstWeekday = [self weekdayOfFirsDayInMonth];
    // 第一行的天数
    NSInteger firstRowDay = 7 - (firstWeekday - 1);
    // 除去第一行的整行数
    NSInteger row = (totalDays - firstRowDay) / 7;
    // 最后一行的天数
    NSInteger lastRowDay = totalDays - firstRowDay - row * 7;
    if (lastRowDay != 0) {
        row++;
    }
    row++;
    return row;
}

- (NSString *)monthTitle
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    return [formatter stringFromDate:self];
}

@end
