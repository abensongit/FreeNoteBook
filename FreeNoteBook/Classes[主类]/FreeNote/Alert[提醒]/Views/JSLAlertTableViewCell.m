
#import "JSLAlertTableViewCell.h"

@interface JSLAlertTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *tipsImageView;
@property (nonatomic, strong) UIView  *dividerViewTop;
@property (nonatomic, strong) UIView  *dividerViewBottom;
@end

@implementation JSLAlertTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [self.contentView addSubview:self.titleLabel];
        
        [self.contentView addSubview:self.dividerViewTop];
        [self.dividerViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView);
            make.left.right.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(2.0f);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(10);
            make.top.equalTo(weakSelf.dividerViewTop.mas_bottom).with.offset(20);
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.remarkLabel];
        [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(10);
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(2);
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-35);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).with.offset(10);
            make.right.equalTo(weakSelf.contentView).with.offset(-10);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-15);
            make.height.mas_equalTo(15);
        }];
        
        [self.contentView addSubview:self.tipsImageView];
        [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(80);
            make.top.equalTo(weakSelf.contentView).with.offset(20);
            make.right.equalTo(weakSelf.contentView).with.offset(-20);
        }];
        
        [self.contentView addSubview:self.dividerViewBottom];
        [self.dividerViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(2.0f);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:JSL_AUTOSIZING_FONT_SCALE(20.0f)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}


- (UILabel *)remarkLabel
{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [UIColor whiteColor];
        _remarkLabel.font = [UIFont systemFontOfSize:JSL_AUTOSIZING_FONT_SCALE(16.0f)];
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _remarkLabel;
}


- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:JSL_AUTOSIZING_FONT_SCALE(15.0f)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _timeLabel;
}


- (void)updateCellWithAlertInfo:(JSLAlertInfo *)alertInfo color:(UIColor *)color
{
    self.contentView.backgroundColor = color;
    self.titleLabel.text = alertInfo.alertName;
    self.remarkLabel.text = alertInfo.alertRemark;
    NSString *dateStr = [self formateDate:alertInfo.alertDate];
    NSString *resultStr = nil;
    switch (alertInfo.alertRepeatType) {
        case kJSLAlertRepeatTypeNever:
            resultStr = dateStr;
            break;
            
        case kJSLAlertRepeatTypeDay:
            resultStr = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"每天", nil),  [dateStr substringWithRange:NSMakeRange(6, 5)]];
            break;
            
        case kJSLAlertRepeatTypeWeekday:
            resultStr = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"每周", nil), [self weekdayStringFromDate:alertInfo.alertDate], [dateStr substringWithRange:NSMakeRange(6, 5)]];
            break;
            
        case kJSLAlertRepeatTypeMonth:
            resultStr = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"每月", nil), [dateStr substringWithRange:NSMakeRange(3, 2)], [dateStr substringWithRange:NSMakeRange(6, 5)]];
            break;
            
        default:
            break;
    }
    
    self.timeLabel.text = resultStr;
    
    if (alertInfo.isFinish) {
        self.tipsImageView.hidden = NO;
        if (alertInfo.isComplete) {
            self.tipsImageView.image = [UIImage imageNamed:ICON_ALERT_COMPLETE];
        } else {
            self.tipsImageView.image = [UIImage imageNamed:ICON_ALERT_FINISH];
        }
    } else {
        self.tipsImageView.hidden = YES;
    }
}

- (UIImageView *)tipsImageView
{
    if (!_tipsImageView) {
        _tipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 42)];
        _tipsImageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    return _tipsImageView;
}

- (UIView *)dividerViewTop
{
    if (!_dividerViewTop) {
        _dividerViewTop = [[UIView alloc] init];
        _dividerViewTop.backgroundColor = [JSLThemeConfig currentTheme].navBarBGColor;
    }
    
    return _dividerViewTop;
}

- (UIView *)dividerViewBottom
{
    if (!_dividerViewBottom) {
        _dividerViewBottom = [[UIView alloc] init];
        _dividerViewBottom.backgroundColor = [JSLThemeConfig currentTheme].navBarBGColor;
    }
    
    return _dividerViewBottom;
}

- (NSString *)formateDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    return [formatter stringFromDate:date];
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (NSString *)weekdayStringFromDate:(NSDate *)inputDate
{
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], NSLocalizedString(@"周日", nil), NSLocalizedString(@"周一", nil), NSLocalizedString(@"周二", nil), NSLocalizedString(@"周三", nil), NSLocalizedString(@"周四", nil), NSLocalizedString(@"周五", nil), NSLocalizedString(@"周六", nil), nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

#pragma clang diagnostic pop

@end

