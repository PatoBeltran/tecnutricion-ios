//
//  TECHistoryMonthsViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/20/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECHistoryMonthsViewController.h"
#import "IQDropDownTextField.h"
#import "DSBarChart.h"
#import "BTSpiderPlotterView.h"
#import "TECNutreTecCore.h"
#import "TECUserDiet.h"
#import "TECDaySummary.h"

@interface TECHistoryMonthsViewController () <IQDropDownTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *innerWrapperView;
@property (weak, nonatomic) IBOutlet UIView *noMonthsAlert;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *monthChooser;
@property (weak, nonatomic) IBOutlet UIView *tabGraphWrapper;
@property (weak, nonatomic) IBOutlet UIView *spiderPlotWrapper;
@property (strong, nonatomic) BTSpiderPlotterView *spiderPlot;
@property (strong, nonatomic) DSBarChart *barChart;
@property (strong, nonatomic) NSArray *monthAmount;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *weeks;
@property (strong, nonatomic) TECUserDiet *diet;
@property (strong, nonatomic) TECDaySummary *progress;
@property (nonatomic) NSInteger firstMonday;
@property (nonatomic) BOOL canrun;
@end

@implementation TECHistoryMonthsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Generate drop list of past entries
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day"
                                              inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    [request setEntity:entity];
    
    NSError *error;
    NSArray *matchObjects = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    
    if (matchObjects.count < 29) {
        self.noMonthsAlert.hidden = NO;
        self.innerWrapperView.hidden = YES;
    }
    else {
        self.noMonthsAlert.hidden = YES;
        self.innerWrapperView.hidden = NO;
        
        //Spider Plot
        self.spiderPlot = [[BTSpiderPlotterView alloc] initWithFrame:CGRectMake(self.spiderPlotWrapper.frame.origin.x + 25, self.spiderPlotWrapper.frame.origin.y + 25, self.spiderPlotWrapper.frame.size.width - 50, self.spiderPlotWrapper.frame.size.height - 50)
                                                     valueDictionary:@{ @"vegetables-color-icon-mini" : @"6",
                                                                        @"milk-color-icon-mini"       : @"1",
                                                                        @"meat-color-icon-mini"       : @"4",
                                                                        @"sugar-color-icon-mini"      : @"5",
                                                                        @"pea-color-icon-mini"        : @"2",
                                                                        @"fruit-color-icon-mini"      : @"8",
                                                                        @"cereal-color-icon-mini"     : @"7",
                                                                        @"fat-color-icon-mini"        : @"2"}];
        
        self.spiderPlot.plotColor = [UIColor colorWithRed:82./255 green:192./255 blue:202./255 alpha:0.7];
        self.spiderPlot.drawboardColor = [UIColor colorWithRed:185./255 green:185./255 blue:185./255 alpha:1.0];
        [self.spiderPlotWrapper addSubview:self.spiderPlot];
        
        
        //Month Chooser
        self.monthChooser.isOptionalDropDown = NO;
        self.monthChooser.delegate = self;
        [self.monthChooser setItemList:[NSArray arrayWithObjects:@"Marzo 15 - 21",@"Marzo 22 - 29",@"Marzo 29 - 5",@"Abril 6 - 13", nil]];
        
        UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
        
        [self.view addGestureRecognizer:tapBackground];
        [self.view addGestureRecognizer:swipeDown];
        
        //@TODO - Give first of list
        [self updateSpiderPlotForItem:@""];
        
        
        //Bar Chart
        
        self.monthAmount = [NSArray arrayWithObjects:
                            [NSNumber numberWithInt:30],
                            [NSNumber numberWithInt:40],
                            [NSNumber numberWithInt:20],
                            [NSNumber numberWithInt:56],
                            [NSNumber numberWithInt:70],
                            [NSNumber numberWithInt:34],
                            [NSNumber numberWithInt:43],
                            nil];
        
        self.barChart = [[DSBarChart alloc] initWithFrame:self.tabGraphWrapper.bounds
                                                   values:self.monthAmount
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
    self.monthAmount = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:50],
                       [NSNumber numberWithInt:10],
                       [NSNumber numberWithInt:70],
                       [NSNumber numberWithInt:46],
                       [NSNumber numberWithInt:90],
                       [NSNumber numberWithInt:34],
                       [NSNumber numberWithInt:13],
                       nil];
    
    [self.barChart changeValues:self.monthAmount];
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
