//
//  FLCalendarItemCell.h
//  FlowLayout
//
//  Created by Fuzzie Liu on 15/11/2.
//  Copyright © 2015年 Fuzzie Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLCalendarItemCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *chineseDateLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSDate *calendarDate;
@property (nonatomic, strong) NSDate *cellDate;
@property (nonatomic, strong) NSDateComponents *cellComponents;

- (void)setUpDateLabelWithIndexPath :(NSIndexPath *)indexPath;

@end
