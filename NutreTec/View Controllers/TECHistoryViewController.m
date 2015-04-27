//
//  TECHistoryViewController.m
//  NutreTec
//
//  Created by Gerardo Luna  on 4/26/15.
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

@property (nonatomic, assign) BOOL canrun;
@property (nonatomic, strong) TECUserDiet *diet;
@property (strong, nonatomic) TECDaySummary *dayProgress;
@property (strong, nonatomic) NSDate *dayBefore;
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end

@implementation TECHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Generate drop list of past entries
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day"
                                              inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *matchObjects = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    
    if ([matchObjects count] <= 1) {
        self.canrun = NO;
        self.noDaysAlert.hidden = NO;
        self.innerWrapperView.hidden = YES;
    }
    else {
        self.canrun = YES;
        self.noDaysAlert.hidden = YES;
        self.innerWrapperView.hidden = NO;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MM/yyyy"];
        self.dayBefore = [df dateFromString: [matchObjects[matchObjects.count-2] valueForKey:@"day"]];
    
        [self.view addSubview:self.calendarView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.canrun){
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
        [self setProgress:self.dayBefore];
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

- (void)setProgress:(NSDate *)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    [self getProgressFromDBForDate:[dateFormat stringFromDate:date]];
    
    if (self.dayProgress) {
        self.noInfoOnDayAlert.hidden = YES;
        self.innerWrapperView.hidden = NO;
        
        [self getDietFromDate:self.dayProgress.dietId];
        
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

#pragma mark - Database Interaction

- (void)getProgressFromDBForDate:(NSString *)date {
    self.dayProgress = [TECDaySummary initFromDatabaseWithDate:date];
}

- (void)getDietFromDate:(NSString *)date {
    self.diet = [TECUserDiet initFromDateInDatabase:date];
}

- (void)updateValuesForItem:(NSDate *)date {
    [self setProgress:date];
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
    [self updateValuesForItem:date];
}

- (UIImage *)infoImageForDay:(NSDate *)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    TECDaySummary *infoDay = [TECDaySummary initFromDatabaseWithDate:[dateFormat stringFromDate:date]];
    
    if (infoDay) {
        if ([infoDay checkIfDietWasMade]) {
           return [UIImage imageNamed:@"daily-check"];
        }
        return [UIImage imageNamed:@"daily-cross"];
    }
    return nil;
}

@end
