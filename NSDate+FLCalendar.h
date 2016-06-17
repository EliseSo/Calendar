//
//  NSDate+FLCalendar.h
//  FlowLayout
//
//  Created by Fuzzie Liu on 15/11/2.
//  Copyright © 2015年 Fuzzie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FLCalendar)

- (NSInteger)weekdayOfFirsDayInMonth;

- (NSInteger)numbersOfDaysInMonth;

- (NSDate *)previousMonthDate;

- (NSDate *)nextMonthDate;

// 这个月跨了几周
- (NSInteger)weeksInMonth;

- (NSString *)monthTitle;

@end
