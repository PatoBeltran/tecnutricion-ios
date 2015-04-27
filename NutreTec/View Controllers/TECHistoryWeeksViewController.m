//
//  TecHistoryWeeksViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/20/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECHistoryWeeksViewController.h"
#import "BTSpiderPlotterView.h"
#import "IQDropDownTextField.h"
#import "DSBarChart.h"
#import "TECNutreTecCore.h"
#import "TECDaySummary.h"
#import "TECUserDiet.h"
#import "CLWeeklyCalendarView.h"

static CGFloat CALENDER_VIEW_HEIGHT = 150.f;

@interface TECHistoryWeeksViewController () <IQDropDownTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *innerWrapperView;
@property (weak, nonatomic) IBOutlet UIView *noWeeksAlert;
@property (strong, nonatomic) NSArray *weekAmount;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *weeks;
@property (strong, nonatomic) TECUserDiet *diet;
@property (strong, nonatomic) TECDaySummary *progress;
@property (nonatomic) NSInteger firstMonday;
@property (nonatomic) BOOL canrun;
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end

@implementation TECHistoryWeeksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canrun = false;
    self.days = [[NSMutableArray alloc] init];
    self.weeks = [[NSMutableArray alloc] init];
    
    //Fetch weeks
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Week"
                                              inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *matchObjects = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    
    //Get days
    NSFetchRequest *requestDay = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDay = [NSEntityDescription entityForName:@"Day"
                                              inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    [requestDay setEntity:entityDay];
    
    NSError *errorDay;
    NSArray *matchObjectsDay = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:requestDay error:&errorDay];
    
    self.firstMonday = 0;
    
    if (matchObjects.count != 0) {
        NSString *lastSunday = [[matchObjects lastObject] valueForKey:@"end"];
        long i=0;
        while(![[matchObjectsDay[i] valueForKey:@"day"] isEqualToString: lastSunday]){
            i++;
            self.firstMonday = i;
        }
        self.firstMonday = self.firstMonday + 1;
    }

    for(long i=matchObjectsDay.count-2; i>=self.firstMonday; i--){
        NSString *day, *name;
        day = [matchObjectsDay[i] valueForKey:@"day"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MM/yyyy"];
        NSDate *myDate = [df dateFromString: day];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE, dd MMMM yyyy"];
        day = [formatter stringFromDate:myDate];
        name = [day componentsSeparatedByString:@","][0];

        if([name isEqualToString:@"Sunday"]){
            self.canrun = true;
        }
        [self.days addObject:day];
    }
    
//    if (!self.canrun && matchObjects.count == 0) {
//        self.noWeeksAlert.hidden = NO;
//        self.innerWrapperView.hidden = YES;
//    }
//    else {
        self.noWeeksAlert.hidden = YES;
        self.innerWrapperView.hidden = NO;
        
        NSString *date, *startDate;
        NSInteger milk, meat, pea, fruit, fat, cereal, sugar, vegetable;
        milk = meat = pea = fruit = fat = cereal = sugar = vegetable = 0;
        NSInteger milkT, meatT, peaT, fruitT, fatT, cerealT, sugarT, vegetableT;
        milkT = meatT = peaT = fruitT = fatT = cerealT = sugarT = vegetableT = 0;
        
        //Generate week tables
        for(long i=self.days.count-1; i>=0; i--){
            //When sunday is found make entry in week table
            while((![[self.days[i] componentsSeparatedByString:@","][0] isEqualToString:@"Sunday"]) && i>0){
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"EEEE, dd MMMM yyyy"];
                NSDate *myDate = [df dateFromString: self.days[i]];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd/MM/yyyy"];
                date = [formatter stringFromDate:myDate];
                if(milk==0&&meat==0&&pea==0&&fruit==0&&fat==0&&cereal==0&&sugar==0&&vegetable==0){
                    startDate = date;
                }
                
                //Obtain progress and diet according to date
                self.progress = [TECDaySummary initFromDatabaseWithDate:date];
                self.diet = [TECUserDiet initFromDateInDatabase:self.progress.dietId];
                
                milk+=self.progress.milk.consumed;
                meat+=self.progress.meat.consumed;
                pea+=self.progress.pea.consumed;
                fruit+=self.progress.fruit.consumed;
                fat+=self.progress.fat.consumed;
                cereal+=self.progress.cereal.consumed;
                sugar+=self.progress.sugar.consumed;
                vegetable+=self.progress.vegetable.consumed;
                
                milkT+=self.diet.milkAmount;
                meatT+=self.diet.meatAmount;
                peaT+=self.diet.peaAmount;
                fruitT+=self.diet.fruitAmount;
                fatT+=self.diet.fatAmount;
                cerealT+=self.diet.cerealAmount;
                sugarT+=self.diet.sugarAmount;
                vegetableT+=self.diet.vegetablesAmount;
                i--;
            }
            if ([[self.days[i] componentsSeparatedByString:@","][0] isEqualToString:@"Sunday"]) {
                NSManagedObject *newWeek = [NSEntityDescription insertNewObjectForEntityForName:@"Week"
                                                                         inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"EEEE, dd MMMM yyyy"];
                NSDate *myDate = [df dateFromString: self.days[i]];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd/MM/yyyy"];
                date = [formatter stringFromDate:myDate];
                [newWeek setValue:startDate forKey:@"start"];
                [newWeek setValue:date forKey:@"end"];
                
                //Obtain progress and diet according to date
                self.progress = [TECDaySummary initFromDatabaseWithDate:date];
                self.diet = [TECUserDiet initFromDateInDatabase:self.progress.dietId];
                
                milk+=self.progress.milk.consumed;
                meat+=self.progress.meat.consumed;
                pea+=self.progress.pea.consumed;
                fruit+=self.progress.fruit.consumed;
                fat+=self.progress.fat.consumed;
                cereal+=self.progress.cereal.consumed;
                sugar+=self.progress.sugar.consumed;
                vegetable+=self.progress.vegetable.consumed;
                
                milkT+=self.diet.milkAmount;
                meatT+=self.diet.meatAmount;
                peaT+=self.diet.peaAmount;
                fruitT+=self.diet.fruitAmount;
                fatT+=self.diet.fatAmount;
                cerealT+=self.diet.cerealAmount;
                sugarT+=self.diet.sugarAmount;
                vegetableT+=self.diet.vegetablesAmount;
                
                NSInteger milkP = (double) milk / (double) milkT * 100.0;
                NSInteger meatP = (double) meat / (double) meatT * 100.0;
                NSInteger peaP = (double) pea / (double) peaT * 100.0;
                NSInteger fruitP = (double) fruit / (double) fruitT * 100.0;
                NSInteger fatP = (double) fat / (double) fatT * 100.0;
                NSInteger cerealP = (double) cereal / (double) cerealT * 100.0;
                NSInteger sugarP = (double) sugar / (double) sugarT * 100.0;
                NSInteger vegetableP = (double) vegetable / (double) vegetableT * 100.0;
                
                [newWeek setValue:[NSNumber numberWithInteger:milkP] forKey:@"milk"];
                [newWeek setValue:[NSNumber numberWithInteger:meatP] forKey:@"meat"];
                [newWeek setValue:[NSNumber numberWithInteger:peaP] forKey:@"pea"];
                [newWeek setValue:[NSNumber numberWithInteger:fruitP] forKey:@"fruit"];
                [newWeek setValue:[NSNumber numberWithInteger:fatP] forKey:@"fat"];
                [newWeek setValue:[NSNumber numberWithInteger:cerealP] forKey:@"cereal"];
                [newWeek setValue:[NSNumber numberWithInteger:sugarP] forKey:@"sugar"];
                [newWeek setValue:[NSNumber numberWithInteger:vegetableP] forKey:@"vegetable"];
                
                NSError *error;
                [[[TECNutreTecCore sharedInstance] managedObjectContext] save: &error];
                
                milk = meat = pea = fruit = fat = cereal = sugar = vegetable = 0;
                milkT = meatT = peaT = fruitT = fatT = cerealT = sugarT = vegetableT = 0;
            }
        }
        
        //Fetch all saved weeks
        NSArray *matchObjectsWeeks = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
        
        //Get all weeks into array
        NSManagedObject *matchRegisterWeeks;
        NSString *start, *end;
        for(long i=(matchObjectsWeeks.count-1); i>=0; i--){
            matchRegisterWeeks = matchObjectsWeeks[i];
            start = [matchRegisterWeeks valueForKey:@"start"];
            end = [matchRegisterWeeks valueForKey:@"end"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"dd/MM/yyyy"];
            NSDate *sStart = [df dateFromString: start];
            NSDate *sEnd = [df dateFromString: end];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"EEEE, dd MMMM yyyy"];
            start = [formatter stringFromDate:sStart];
            end = [formatter stringFromDate:sEnd];
            NSString *week = [start stringByAppendingString:@" - "];
            week = [week stringByAppendingString:end];
            [self.weeks addObject:week];
        }
        
//        //Spider Plot
//        self.spiderPlot = [[BTSpiderPlotterView alloc] initWithFrame:CGRectMake(self.spiderPlotWrapper.frame.origin.x + 25, self.spiderPlotWrapper.frame.origin.y + 25, self.spiderPlotWrapper.frame.size.width - 50, self.spiderPlotWrapper.frame.size.height - 50)
//                                                     valueDictionary:@{ @"vegetables-color-icon-mini" : [matchObjectsWeeks.lastObject valueForKey:@"vegetable"],
//                                                                        @"milk-color-icon-mini"       : [matchObjectsWeeks.lastObject valueForKey:@"milk"],
//                                                                        @"meat-color-icon-mini"       : [matchObjectsWeeks.lastObject valueForKey:@"meat"],
//                                                                        @"sugar-color-icon-mini"      : [matchObjectsWeeks.lastObject valueForKey:@"sugar"],
//                                                                        @"pea-color-icon-mini"        : [matchObjectsWeeks.lastObject valueForKey:@"pea"],
//                                                                        @"fruit-color-icon-mini"      : [matchObjectsWeeks.lastObject valueForKey:@"fruit"],
//                                                                        @"cereal-color-icon-mini"     : [matchObjectsWeeks.lastObject valueForKey:@"cereal"],
//                                                                        @"fat-color-icon-mini"        : [matchObjectsWeeks.lastObject valueForKey:@"fat"]}];
//        
//        self.spiderPlot.plotColor = [UIColor colorWithRed:82./255 green:192./255 blue:202./255 alpha:0.7];
//        self.spiderPlot.drawboardColor = [UIColor colorWithRed:185./255 green:185./255 blue:185./255 alpha:1.0];
//        [self.spiderPlotWrapper addSubview:self.spiderPlot];
        
//        //Week Chooser
//        self.weekChooser.isOptionalDropDown = NO;
//        self.weekChooser.delegate = self;
//        [self.weekChooser setItemList:self.weeks];
//        
//        UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
//        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
//        swipeDown.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
//        
//        [self.view addGestureRecognizer:tapBackground];
//        [self.view addGestureRecognizer:swipeDown];
    
        //@TODO - Give first of list
        //[self updateSpiderPlotForItem:@""];
        
        
        //Bar Chart
//        
//        self.weekAmount = [NSArray arrayWithObjects:
//                           [NSNumber numberWithInteger:[[matchObjectsWeeks.lastObject valueForKey:@"vegetable"] integerValue]],
//                           [NSNumber numberWithInteger:[[matchObjectsWeeks.lastObject valueForKey:@"milk"] integerValue]],
//                           [NSNumber numberWithInteger:[[matchObjectsWeeks.lastObject valueForKey:@"meat"] integerValue]],
//                           [NSNumber numberWithInteger:[[matchObjectsWeeks.lastObject valueForKey:@"sugar"] integerValue]],
//                           [NSNumber numberWithInteger:[[matchObjectsWeeks.lastObject valueForKey:@"pea"] integerValue]],
//                           [NSNumber numberWithInteger:[[matchObjectsWeeks.lastObject valueForKey:@"fruit"] integerValue]],
//                           [NSNumber numberWithInteger:[[matchObjectsWeeks.lastObject valueForKey:@"cereal"] integerValue]],
//                           [NSNumber numberWithInteger:[[matchObjectsWeeks.lastObject valueForKey:@"fat"] integerValue]],
//                           nil];
//        
//        self.barChart = [[DSBarChart alloc] initWithFrame:self.tabGraphWrapper.bounds
//                                                   values:self.weekAmount
//                                                   colors:@[TECVegetablesColor, TECMilkColor, TECMeatColor, TECSugarColor, TECPeaColor, TECFruitColor, TECCerealColor, TECFatColor]];
//        
//        
//        self.barChart.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.barChart.bounds = self.tabGraphWrapper.bounds;
//        self.barChart.backgroundColor = [UIColor clearColor];
//        [self.tabGraphWrapper addSubview:self.barChart];
//    }
}

- (void)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

//- (void)updateSpiderPlotForItem:(NSString *)item {
//    NSEntityDescription *entityDiet = [NSEntityDescription entityForName:@"Week"
//                                                  inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"end like %@", item];
//    [fetchRequest setPredicate:predicate];
//    [fetchRequest setEntity:entityDiet];
//    
//    NSError *error;
//    NSArray *matchObjectsDiet = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
//    NSManagedObject *matchRegister = matchObjectsDiet[0];
//    
//    [self.spiderPlot animateWithDuration:0.3 valueDictionary:@{@"vegetables-color-icon-mini" : [matchRegister valueForKey:@"vegetable"],
//                                                               @"milk-color-icon-mini"       : [matchRegister valueForKey:@"milk"],
//                                                               @"meat-color-icon-mini"       : [matchRegister valueForKey:@"meat"],
//                                                               @"sugar-color-icon-mini"      : [matchRegister valueForKey:@"sugar"],
//                                                               @"pea-color-icon-mini"        : [matchRegister valueForKey:@"pea"],
//                                                               @"fruit-color-icon-mini"      : [matchRegister valueForKey:@"fruit"],
//                                                               @"cereal-color-icon-mini"     : [matchRegister valueForKey:@"cereal"],
//                                                               @"fat-color-icon-mini"        : [matchRegister valueForKey:@"fat"]}];
//    
//}


//- (void)updateBarGraphForItem:(NSString *)item {
//    NSEntityDescription *entityDiet = [NSEntityDescription entityForName:@"Week"
//                                                  inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"end like %@", item];
//    [fetchRequest setPredicate:predicate];
//    [fetchRequest setEntity:entityDiet];
//    
//    NSError *error;
//    NSArray *matchObjectsDiet = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
//    NSManagedObject *matchRegister = matchObjectsDiet[0];
//
//    self.weekAmount = [NSArray arrayWithObjects:
//                       [NSNumber numberWithInteger:[[matchRegister valueForKey:@"vegetable"] integerValue]],
//                       [NSNumber numberWithInteger:[[matchRegister valueForKey:@"milk"] integerValue]],
//                       [NSNumber numberWithInteger:[[matchRegister valueForKey:@"meat"] integerValue]],
//                       [NSNumber numberWithInteger:[[matchRegister valueForKey:@"sugar"] integerValue]],
//                       [NSNumber numberWithInteger:[[matchRegister valueForKey:@"pea"] integerValue]],
//                       [NSNumber numberWithInteger:[[matchRegister valueForKey:@"fruit"] integerValue]],
//                       [NSNumber numberWithInteger:[[matchRegister valueForKey:@"cereal"] integerValue]],
//                       [NSNumber numberWithInteger:[[matchRegister valueForKey:@"fat"] integerValue]],
//                       nil];
//    
//    [self.barChart changeValues:self.weekAmount];
//}

- (void)updateValuesForItem:(NSString *)string {
//    [self updateSpiderPlotForItem:string];
//    [self updateBarGraphForItem:string];
}

#pragma mark - UITextFieldDelegate

- (void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMMM yyyy"];
    NSDate *myDate = [df dateFromString: [item componentsSeparatedByString:@","][2]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *string = [formatter stringFromDate:myDate];
    [self updateValuesForItem:string];
}

//#pragma mark - CLWeeklyCalendarViewDelegate
//
//- (CLWeeklyCalendarView *)calendarView {
//    if(!_calendarView){
//        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
//        _calendarView.delegate = self;
//    }
//    return _calendarView;
//}
//
//- (NSDictionary *)CLCalendarBehaviorAttributes {
//    return @{ CLCalendarWeekStartDay : @1 };
//}
//
//- (void)dailyCalendarViewDidSelect:(NSDate *)date {
//    //@TODO - refresh view
//    //You can do any logic after the view select the date
//}


@end
