//
//  TECHistoryWrapperViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/20/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECHistoryWrapperViewController.h"
#import "NutreTec-Swift.h"
#import "TECHistoryDaysViewController.h"
#import "TECHistoryWeeksViewController.h"
#import "TECHistoryMonthsViewController.h"

@interface TECHistoryWrapperViewController () <SlidingContainerViewControllerDelegate>
@property (nonatomic, strong) SlidingContainerViewController *slidingContainerViewController;
@end

@implementation TECHistoryWrapperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TECHistoryDaysViewController *daysVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"daysHistoryController"];


    TECHistoryWeeksViewController *weeksVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"weeksHistoryController"];

    TECHistoryMonthsViewController *monthsVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"monthsHistoryController"];

    self.slidingContainerViewController = [[SlidingContainerViewController alloc] initWithParent:self
                                                                          contentViewControllers:@[daysVc, weeksVc, monthsVc]
                                                                                          titles:@[@"DÍA", @"SEMANA", @"MES"]
                                                                                           icons:@[[UIImage imageNamed:@"day-icon"], [UIImage imageNamed:@"week-icon"], [UIImage imageNamed:@"month-icon"]]];
    self.slidingContainerViewController.delegate = self;
    
    [self.view addSubview:self.slidingContainerViewController.view];
}

- (void)slidingContainerViewControllerDidMoveToViewController:(SlidingContainerViewController * __nonnull)slidingContainerViewController viewController:(UIViewController * __nonnull)viewController atIndex:(NSInteger)atIndex {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
