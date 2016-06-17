//
//  FLCalendar.m
//  FlowLayout
//
//  Created by Fuzzie Liu on 15/10/31.
//  Copyright © 2015年 Fuzzie Liu. All rights reserved.
//

#import "FLCalendar.h"
#import "FLCalendarItemCell.h"
#import "NSDate+FLCalendar.h"

#pragma mark ----显示星期几的cell----
@interface WeekdayCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *weekdayLabel;
@end

@implementation WeekdayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.weekdayLabel = [[UILabel alloc] init];
        _weekdayLabel.textAlignment = NSTextAlignmentCenter;
        _weekdayLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_weekdayLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.weekdayLabel.frame = self.contentView.bounds;
}

@end


#define Weekday @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"]
#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DevieceHeight [UIScreen mainScreen].bounds.size.height
#define TitleViewHeight 40.0f
#define WeekdayViewHeight 20.0f
#define ButtonWidth 70.0f
#define Today 0xff6600
#define SelectedColor 0xff99cc
#define CurrentMonth 0xff9966
#define ItemCellReuse @"ItemCellReuse"
#define WeekdayCellReuse @"WeekdayCellReuse"

@interface FLCalendar ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UICollectionView *weekdayView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton  *titleButton;
@property (nonatomic, assign) NSInteger selectedDay;

@end

@implementation FLCalendar

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.date = date;
        [self setFrame:CGRectMake(0, 0, DeviceWidth, CGRectGetHeight(self.collectionView.bounds))];
        self.backgroundColor = UIColorFromRGB(0xfffafa);
        self.alpha = 0.8;
        [self setUpCollectionView];
        [self loadTitleView];
        [self loadWeekdayView];
        [self addObserver:self forKeyPath:@"date" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
// 用观察者模式来响应date属性值的改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // date改变时重新加载日历, 改变title
    [self.collectionView reloadData];
    [self.titleButton setTitle:[self.date monthTitle] forState:UIControlStateNormal];
}

// 加载日历
- (void)setUpCollectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *calendarLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemLength = DeviceWidth / 7;
        calendarLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        calendarLayout.itemSize = CGSizeMake(itemLength, itemLength);
        calendarLayout.minimumInteritemSpacing = 0;
        calendarLayout.minimumLineSpacing = 0;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TitleViewHeight + WeekdayViewHeight, DeviceWidth, DeviceWidth) collectionViewLayout:calendarLayout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[FLCalendarItemCell class] forCellWithReuseIdentifier:ItemCellReuse];
    }
    [self addSubview:_collectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 星期日cell
    if (collectionView == self.weekdayView) {
        WeekdayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WeekdayCellReuse forIndexPath:indexPath];
        cell.weekdayLabel.text = Weekday[indexPath.item];
        if (indexPath.item == 0 || indexPath.item == 6) {
            cell.weekdayLabel.textColor = [UIColor redColor];
        }
        return cell;
    }
    // 日历cell
    if (collectionView == self.collectionView) {
        FLCalendarItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemCellReuse forIndexPath:indexPath];
        cell.calendarDate = self.date;
        [cell setUpDateLabelWithIndexPath:indexPath];
       
        // 获得当前的时间
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *currentComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        // 当cell代表的时间与当前的时间相同时, 背景颜色变红
        if ([cell.cellComponents isEqual:currentComponents]) {
            cell.backView.backgroundColor = UIColorFromRGB(Today);
        }
        
        // 当月份跳转时, 保持选中的那天日期相同
        NSDateComponents *monthComponents = [calendar components:NSCalendarUnitMonth fromDate:self.date];
        if (monthComponents.month == cell.cellComponents.month && cell.cellComponents.day == self.selectedDay) {
            cell.contentView.hidden = NO;
        }else{
            cell.contentView.hidden = YES;
        }
        return cell;
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.weekdayView) {
        return 7;
    }
    return [self.date weeksInMonth] * 7;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 日期的点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLCalendarItemCell *cell = (FLCalendarItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // 选中后出现灰色的圈
    cell.contentView.hidden = NO;
    
    // 记录选中的日期
    self.selectedDay = cell.cellComponents.day;
    NSLog(@"选中的日期====%ld", self.selectedDay);
    NSDate *selectedDate = [[NSCalendar currentCalendar] dateFromComponents:cell.cellComponents];
    // 获取系统时区的时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:selectedDate];
    selectedDate = [selectedDate dateByAddingTimeInterval:interval];
    [self.delegate calendarItemSelectedAtDate:selectedDate];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLCalendarItemCell *cell = (FLCalendarItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.hidden = YES;
}

// 加载显示星期的collectionView
- (void)loadWeekdayView;
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(DeviceWidth / 7, 20);
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.weekdayView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TitleViewHeight, DeviceWidth, WeekdayViewHeight) collectionViewLayout:layout];
    self.weekdayView.delegate = self;
    self.weekdayView.dataSource = self;
    self.weekdayView.backgroundColor = [UIColor clearColor];
    
    [self.weekdayView registerClass:[WeekdayCell class] forCellWithReuseIdentifier:WeekdayCellReuse];
    [self addSubview:_weekdayView];
}

// 加载标题和左右按钮
- (void)loadTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, TitleViewHeight)];
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _titleButton.frame = CGRectMake(ButtonWidth, 0, DeviceWidth - 2 * ButtonWidth, TitleViewHeight);
    [_titleButton setTitle:[self.date monthTitle] forState:UIControlStateNormal];
    _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleButton.titleLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:_titleButton];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0, 0, ButtonWidth, TitleViewHeight);
    [titleView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"前一个月" forState:UIControlStateNormal];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(DeviceWidth - ButtonWidth, 0, ButtonWidth, TitleViewHeight);
    [titleView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(showNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"后一个月" forState:UIControlStateNormal];
    
    
    [self addSubview:titleView];
}

- (void)showPreviousMonth
{
    self.date = [self.date previousMonthDate];
}

- (void)showNextMonth
{
    self.date = [self.date nextMonthDate];
}

@end
