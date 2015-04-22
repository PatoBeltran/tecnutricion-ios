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

@interface TECHistoryWeeksViewController () <IQDropDownTextFieldDelegate>
@property (weak, nonatomic) IBOutlet IQDropDownTextField *weekChooser;
@property (weak, nonatomic) IBOutlet UIView *tabGraphWrapper;
@property (weak, nonatomic) IBOutlet UIView *spiderPlotWrapper;
@property (strong, nonatomic) BTSpiderPlotterView *spiderPlot;
@end

@implementation TECHistoryWeeksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    self.weekChooser.isOptionalDropDown = NO;
    self.weekChooser.delegate = self;
    [self.weekChooser setItemList:[NSArray arrayWithObjects:@"Marzo 15 - 21",@"Marzo 22 - 29",@"Marzo 29 - 5",@"Abril 6 - 13", nil]];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
    
    [self.view addGestureRecognizer:tapBackground];
    [self.view addGestureRecognizer:swipeDown];
    
    //@TODO - Give first of list
    [self updateSpiderPlotForItem:@""];
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

- (void)updateValuesForItem:(NSString *)string {
    //    [self getValuesFromDBForDate:string];
    [self updateSpiderPlotForItem:string];
}

#pragma mark - UITextFieldDelegate

- (void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item {
    [self updateValuesForItem:item];
}

@end
