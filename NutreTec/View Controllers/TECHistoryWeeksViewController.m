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

@interface TECHistoryWeeksViewController () <IQDropDownTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *innerWrapperView;
@property (weak, nonatomic) IBOutlet UIView *noWeeksAlert;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *weekChooser;
@property (weak, nonatomic) IBOutlet UIView *tabGraphWrapper;
@property (weak, nonatomic) IBOutlet UIView *spiderPlotWrapper;
@property (strong, nonatomic) BTSpiderPlotterView *spiderPlot;
@property (strong, nonatomic) DSBarChart *barChart;
@property (strong, nonatomic) NSArray *weekAmount;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *weeks;
@property (strong, nonatomic) TECUserDiet *diet;
@property (strong, nonatomic) TECDaySummary *progress;
@property (nonatomic) BOOL canrun;
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
    
    for(long i=matchObjectsDay.count-2; i>=0; i--){
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
    
    if (!self.canrun) {
        self.noWeeksAlert.hidden = NO;
        self.innerWrapperView.hidden = YES;
    }
    else {
        self.noWeeksAlert.hidden = YES;
        self.innerWrapperView.hidden = NO;
        
        NSString *date;
        NSInteger milk, meat, pea, fruit, fat, cereal, sugar, vegetable;
        milk = meat = pea = fruit = fat = cereal = sugar = vegetable = 0;
        NSInteger milkT, meatT, peaT, fruitT, fatT, cerealT, sugarT, vegetableT;
        milkT = meatT = peaT = fruitT = fatT = cerealT = sugarT = vegetableT = 0;
        //Generate week tables
        if(matchObjects.count == 0) {
            NSManagedObject *newWeek = [NSEntityDescription insertNewObjectForEntityForName:@"Week"
                                                                     inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
            for(long i=self.days.count-1; i>=0; i--){
                //When sunday is found make entry in week table
                if([[self.days[i] componentsSeparatedByString:@","][0] isEqualToString:@"Sunday"]){
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"EEEE, dd MMMM yyyy"];
                    NSDate *myDate = [df dateFromString: self.days[i]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd/MM/yyyy"];
                    date = [formatter stringFromDate:myDate];
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
                    
                    int milkP = (double) milk / (double) milkT * 100.0;
                    int meatP = (double) meat / (double) meatT * 100.0;
                    int peaP = (double) pea / (double) peaT * 100.0;
                    int fruitP = (double) fruit / (double) fruitT * 100.0;
                    int fatP = (double) fat / (double) fatT * 100.0;
                    int cerealP = (double) cereal / (double) cerealT * 100.0;
                    int sugarP = (double) sugar / (double) sugarT * 100.0;
                    int vegetableP = (double) vegetable / (double) vegetableT * 100.0;
                    
                    printf("%d %d %d %d %d %d %d %d\n", milkP, meatP, peaP, fruitP, fatP, cerealP, sugarP, vegetableP);
                    
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
                }
                else {
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"EEEE, dd MMMM yyyy"];
                    NSDate *myDate = [df dateFromString: self.days[i]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd/MM/yyyy"];
                    date = [formatter stringFromDate:myDate];
                    
                    if(milk==0&&meat==0&&pea==0&&fruit==0&&fat==0&&cereal==0&&sugar==0&&vegetable==0){
                        [newWeek setValue:date forKey:@"start"];
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
                }
            }
        }
        
        //@TODO save weeks when there is already one in db
        
        //Fetch all saved weeks
        matchObjects = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
        
        //Get all weeks into array
        NSManagedObject *matchRegister;
        NSString *start, *end;
        for(long i=(matchObjects.count-1); i>=0; i--){
            matchRegister = matchObjects[i];
            start = [matchRegister valueForKey:@"start"];
            end = [matchRegister valueForKey:@"end"];
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
        
        //Spider Plot
        self.spiderPlot = [[BTSpiderPlotterView alloc] initWithFrame:CGRectMake(self.spiderPlotWrapper.frame.origin.x + 25, self.spiderPlotWrapper.frame.origin.y + 25, self.spiderPlotWrapper.frame.size.width - 50, self.spiderPlotWrapper.frame.size.height - 50)
                                                     valueDictionary:@{ @"vegetables-color-icon-mini" : [matchObjects.lastObject valueForKey:@"vegetable"],
                                                                        @"milk-color-icon-mini"       : [matchObjects.lastObject valueForKey:@"milk"],
                                                                        @"meat-color-icon-mini"       : [matchObjects.lastObject valueForKey:@"meat"],
                                                                        @"sugar-color-icon-mini"      : [matchObjects.lastObject valueForKey:@"sugar"],
                                                                        @"pea-color-icon-mini"        : [matchObjects.lastObject valueForKey:@"pea"],
                                                                        @"fruit-color-icon-mini"      : [matchObjects.lastObject valueForKey:@"fruit"],
                                                                        @"cereal-color-icon-mini"     : [matchObjects.lastObject valueForKey:@"cereal"],
                                                                        @"fat-color-icon-mini"        : [matchObjects.lastObject valueForKey:@"fat"]}];
        
        self.spiderPlot.plotColor = [UIColor colorWithRed:82./255 green:192./255 blue:202./255 alpha:0.7];
        self.spiderPlot.drawboardColor = [UIColor colorWithRed:185./255 green:185./255 blue:185./255 alpha:1.0];
        [self.spiderPlotWrapper addSubview:self.spiderPlot];
        
        //Week Chooser
        self.weekChooser.isOptionalDropDown = NO;
        self.weekChooser.delegate = self;
        [self.weekChooser setItemList:self.weeks];
        
        UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
        
        [self.view addGestureRecognizer:tapBackground];
        [self.view addGestureRecognizer:swipeDown];
        
        //@TODO - Give first of list
        //[self updateSpiderPlotForItem:@""];
        
        
        //Bar Chart
        
        self.weekAmount = [NSArray arrayWithObjects:
                           [NSNumber numberWithInteger:[[matchObjects.lastObject valueForKey:@"vegetable"] integerValue]],
                           [NSNumber numberWithInteger:[[matchObjects.lastObject valueForKey:@"milk"] integerValue]],
                           [NSNumber numberWithInteger:[[matchObjects.lastObject valueForKey:@"meat"] integerValue]],
                           [NSNumber numberWithInteger:[[matchObjects.lastObject valueForKey:@"sugar"] integerValue]],
                           [NSNumber numberWithInteger:[[matchObjects.lastObject valueForKey:@"pea"] integerValue]],
                           [NSNumber numberWithInteger:[[matchObjects.lastObject valueForKey:@"fruit"] integerValue]],
                           [NSNumber numberWithInteger:[[matchObjects.lastObject valueForKey:@"cereal"] integerValue]],
                           [NSNumber numberWithInteger:[[matchObjects.lastObject valueForKey:@"fat"] integerValue]],
                           nil];
        
        self.barChart = [[DSBarChart alloc] initWithFrame:self.tabGraphWrapper.bounds
                                                   values:self.weekAmount
                                                   colors:@[TECVegetablesColor, TECMilkColor, TECMeatColor, TECSugarColor, TECPeaColor, TECFruitColor, TECCerealColor, TECFatColor]];
        
        
        self.barChart.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.barChart.bounds = self.tabGraphWrapper.bounds;
        self.barChart.backgroundColor = [UIColor clearColor];
        [self.tabGraphWrapper addSubview:self.barChart];
    }
}

- (void)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)updateSpiderPlotForItem:(NSString *)item {
    //@TODO - actually update it
    [self.spiderPlot animateWithDuration:0.3 valueDictionary:@{@"vegetables-color-icon-mini" : @"6",
                                                               @"milk-color-icon-mini"       : @"1",
                                                               @"meat-color-icon-mini"       : @"4",
                                                               @"sugar-color-icon-mini"      : @"5",
                                                               @"pea-color-icon-mini"        : @"2",
                                                               @"fruit-color-icon-mini"      : @"8",
                                                               @"cereal-color-icon-mini"     : @"7",
                                                               @"fat-color-icon-mini"        : @"2"}];
    
}


- (void)updateBarGraphForItem:(NSString *)item {
    //@TODO - actually update it
    self.weekAmount = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:50],
                       [NSNumber numberWithInt:10],
                       [NSNumber numberWithInt:70],
                       [NSNumber numberWithInt:46],
                       [NSNumber numberWithInt:90],
                       [NSNumber numberWithInt:34],
                       [NSNumber numberWithInt:13],
                       nil];
    
    [self.barChart changeValues:self.weekAmount];
}

- (void)updateValuesForItem:(NSString *)string {
    //    [self getValuesFromDBForDate:string];
    [self updateSpiderPlotForItem:string];
    [self updateBarGraphForItem:string];
}

#pragma mark - UITextFieldDelegate

- (void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item {
    [self updateValuesForItem:item];
}

@end
