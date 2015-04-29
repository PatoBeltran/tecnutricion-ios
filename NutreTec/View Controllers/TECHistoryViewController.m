//
//  TECHistoryViewController.m
//  NutreTec
//
//  Created by Patricio Beltran  on 4/26/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECHistoryViewController.h"
#import "ILLoaderProgressView.h"
#import "TECNutreTecCore.h"
#import "TECUserDiet.h"
#import "CLWeeklyCalendarView.h"
#import "TECDaySummary.h"

@interface TECHistoryViewController () <CLWeeklyCalendarViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *noDaysAlert;
@property (weak, nonatomic) IBOutlet UIView *innerWrapperView;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *vegetablesProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *milkProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *meatProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *sugarProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *peasProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *fruitProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *cerealProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *fatProgress;
@property (weak, nonatomic) IBOutlet UIView *noInfoOnDayAlert;

@property (nonatomic, assign) BOOL canRun;
@property (nonatomic, strong) TECUserDiet *diet;
@property (strong, nonatomic) TECDaySummary *dayProgress;
@property (strong, nonatomic) NSDate *yesterday;
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end

@implementation TECHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([TECDaySummary hasHistoryDays]) {
        self.canRun = YES;
        self.noDaysAlert.hidden = YES;
        self.innerWrapperView.hidden = NO;
        [self setProgressForDate:[NSDate dateWithTimeIntervalSinceNow:-86400]];
        [self.view addSubview:self.calendarView];
    }
    else {
        self.canRun = NO;
        self.noDaysAlert.hidden = NO;
        self.innerWrapperView.hidden = YES;
        self.noInfoOnDayAlert.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.canRun){
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        [self.vegetablesProgress setupProgressIndicator];
        [self.milkProgress setupProgressIndicator];
        [self.meatProgress setupProgressIndicator];
        [self.sugarProgress setupProgressIndicator];
        [self.peasProgress setupProgressIndicator];
        [self.fruitProgress setupProgressIndicator];
        [self.cerealProgress setupProgressIndicator];
        [self.fatProgress setupProgressIndicator];
        [self setupColorsForView];
    }
}

#pragma mark - Progress Interaction

- (void)setupColorsForView {
    [self.vegetablesProgress setProgressColor:TECVegetablesColor];
    [self.milkProgress setProgressColor:TECMilkColor];
    [self.meatProgress setProgressColor:TECMeatColor];
    [self.sugarProgress setProgressColor:TECSugarColor];
    [self.peasProgress setProgressColor:TECPeaColor];
    [self.fruitProgress setProgressColor:TECFruitColor];
    [self.cerealProgress setProgressColor:TECCerealColor];
    [self.fatProgress setProgressColor:TECFatColor];
}

- (void)setProgressForDate:(NSDate *)date {
    self.dayProgress = [TECDaySummary initFromDatabaseWithDate:date];
    
    if (self.dayProgress) {
        self.noInfoOnDayAlert.hidden = YES;
        self.innerWrapperView.hidden = NO;
        
        self.diet = [TECUserDiet initFromIdInDatabase:self.dayProgress.dietId];
        [self.vegetablesProgress setProgressValue:self.dayProgress.vegetable.consumed forAmount:self.diet.vegetablesAmount];
        [self.milkProgress setProgressValue:self.dayProgress.milk.consumed forAmount:self.diet.milkAmount];
        [self.meatProgress setProgressValue:self.dayProgress.meat.consumed forAmount:self.diet.meatAmount];
        [self.sugarProgress setProgressValue:self.dayProgress.sugar.consumed forAmount:self.diet.sugarAmount];
        [self.peasProgress setProgressValue:self.dayProgress.pea.consumed forAmount:self.diet.peaAmount];
        [self.fruitProgress setProgressValue:self.dayProgress.fruit.consumed forAmount:self.diet.fruitAmount];
        [self.cerealProgress setProgressValue:self.dayProgress.cereal.consumed forAmount:self.diet.cerealAmount];
        [self.fatProgress setProgressValue:self.dayProgress.fat.consumed forAmount:self.diet.fatAmount];
    }
    else {
        self.noInfoOnDayAlert.hidden = NO;
        self.innerWrapperView.hidden = YES;
    }
}

#pragma mark - CLWeeklyCalendarViewDelegate

- (CLWeeklyCalendarView *)calendarView {
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 85, self.view.bounds.size.width, 100.0)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

- (NSDictionary *)CLCalendarBehaviorAttributes {
    return @{ CLCalendarWeekStartDay : @1 };
}

- (void)dailyCalendarViewDidSelect:(NSDate *)date {
    [self setProgressForDate:date];
}

- (UIImage *)infoImageForDay:(NSDate *)date {
    TECDaySummary *infoDay = [TECDaySummary initFromDatabaseWithDate:date];
    if (infoDay) {
        if ([infoDay dietAccomplished]) {
           return [UIImage imageNamed:@"daily-check"];
        }
        return [UIImage imageNamed:@"daily-cross"];
    }
    return nil;
}

@end
