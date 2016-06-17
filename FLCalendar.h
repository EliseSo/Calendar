//
//  FLCalendar.h
//  FlowLayout
//
//  Created by Fuzzie Liu on 15/10/31.
//  Copyright © 2015年 Fuzzie Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLCalendarDelegate <NSObject>
// 需要代理调用的点击日历的方法
@optional
- (void)calendarItemSelectedAtDate: (NSDate *)date;

@end

@interface FLCalendar : UIView

- (instancetype)initWithDate: (NSDate *)date;
@property (nonatomic, assign) id<FLCalendarDelegate>delegate;



@end
