//
//  DailyCalendarView.m
//  Deputy
//
//  Created by Caesar on 30/10/2014.
//  Copyright (c) 2014 Caesar Li
//
#import "DailyCalendarView.h"
#import "NSDate+CL.h"
#import "UIColor+CL.h"

@interface DailyCalendarView()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *dateLabelContainer;
@property (nonatomic, strong) UIView *dateContainer;
@property (nonatomic, strong) UIImageView *infoImageView;
@end

#define DATE_LABEL_SIZE 28
#define DATE_INFO_IMAGE_SIZE 18
#define DATE_LABEL_FONT_SIZE 13

@implementation DailyCalendarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dateContainer];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dailyViewDidClick:)];
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}

-(UIView *)dateContainer {
    if(!_dateContainer){
        float x = (self.bounds.size.width - DATE_LABEL_SIZE)/2;
        _dateContainer = [[UIView alloc] initWithFrame:CGRectMake(x, 0, DATE_LABEL_SIZE, DATE_LABEL_SIZE + DATE_INFO_IMAGE_SIZE + 5.0)];
        _dateContainer.backgroundColor = [UIColor clearColor];
        [_dateContainer addSubview:self.dateLabelContainer];
        [_dateContainer addSubview:self.infoImageView];
    }
    return _dateContainer;
}

-(UIView *)dateLabelContainer {
    if(!_dateLabelContainer){
        _dateLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DATE_LABEL_SIZE, DATE_LABEL_SIZE)];
        _dateLabelContainer.backgroundColor = [UIColor clearColor];
        _dateLabelContainer.layer.cornerRadius = DATE_LABEL_SIZE/2;
        _dateLabelContainer.clipsToBounds = YES;
        [_dateLabelContainer addSubview:self.dateLabel];
    }
    return _dateLabelContainer;
}

-(UILabel *)dateLabel {
    if(!_dateLabel){
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DATE_LABEL_SIZE, DATE_LABEL_SIZE)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:DATE_LABEL_FONT_SIZE];
    }
    return _dateLabel;
}

-(UIImageView *)infoImageView {
    if (!_infoImageView) {
        _infoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, DATE_LABEL_SIZE + 5.0, DATE_INFO_IMAGE_SIZE, DATE_INFO_IMAGE_SIZE)];
    }
    return _infoImageView;
}

-(void)setDate:(NSDate *)date {
    _date = date;
    
    [self setNeedsDisplay];
}
-(void)setBlnSelected: (BOOL)blnSelected {
    _blnSelected = blnSelected;
    [self setNeedsDisplay];
}

-(void)setImage:(UIImage *)image {
    self.infoImageView.image = image;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    self.dateLabel.text = [self.date getDateOfMonth];
    
}

-(void)markSelected:(BOOL)blnSelected {
    if([self.date isDateYesterday]){
        self.dateLabelContainer.backgroundColor = (blnSelected)?[UIColor whiteColor]: [UIColor colorWithHex:0x0081c1];
        self.dateLabel.textColor = (blnSelected)?[UIColor colorWithHex:0x0081c1]:[UIColor whiteColor];
    }
    else{
        self.dateLabelContainer.backgroundColor = (blnSelected)?[UIColor whiteColor]: [UIColor clearColor];
        self.dateLabel.textColor = (blnSelected)?[UIColor colorWithRed:52.0/255.0 green:161.0/255.0 blue:255.0/255.0 alpha:1.0]:[self colorByDate];
    }
}

-(UIColor *)colorByDate {
    return [self.date isPastDate]?[UIColor colorWithHex:0x7BD1FF]:[UIColor whiteColor];
}

-(void)dailyViewDidClick: (UIGestureRecognizer *)tap {
    [self.delegate dailyCalendarViewDidSelect: self.date];
}

@end

