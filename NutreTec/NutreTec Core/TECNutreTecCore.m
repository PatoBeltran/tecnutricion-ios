//
//  TECNutreTecCore.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/2/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECNutreTecCore.h"
#import "TECHistoryDaysViewController.h"
#import "TECHistoryWeeksViewController.h"
#import "TECHistoryMonthsViewController.h"

static TECNutreTecCore *sharedInstance;

@implementation TECNutreTecCore

- (instancetype)init {
    if (sharedInstance) {
        return sharedInstance;
    }
    self = [super init];
    if (self) {
        sharedInstance = self;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_DIET_POPUP_SHOWN]) {
        self.dietPopupHasBeenShown = YES;
    }
    return self;
}

+ (instancetype)sharedInstance {
    @autoreleasepool {
        return (sharedInstance) ? sharedInstance : [[TECNutreTecCore alloc] init];
    }
}

#pragma mark - Diet Manipulation

+ (BOOL)dietPopupHasBeenShown {
    return [TECNutreTecCore sharedInstance].dietPopupHasBeenShown;
}

+ (void)setDietPopupHasBeenShown:(BOOL)flag {
    if (flag) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:USER_DEFAULTS_DIET_POPUP_SHOWN];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULTS_DIET_POPUP_SHOWN];
    }
    
    [TECNutreTecCore sharedInstance].dietPopupHasBeenShown = flag;
}

#pragma mark - History

//+ (void)initPager {
//   NSDictionary *textAttributes = @{
//                                    NSFontAttributeName : [UIFont systemFontOfSize:0.15],
//                                                                     NSForegroundColorAttributeName : [UIColor blackColor]
//                                    };
//    
//    TECHistoryDaysViewController *daysVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"daysHistoryController"];
//    daysVc.pagerObj = [DMPagerNavigationBarItem newItemWithText: [[NSAttributedString alloc] initWithString:@"DÍA" attributes:textAttributes]
//                                                     andIcon: [UIImage imageNamed:@"day-icon"]];
//    
//    daysVc.pagerObj.renderingMode = DMPagerNavigationBarItemModeTextAndImage;
//    
//    TECHistoryWeeksViewController *weeksVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"weeksHistoryController"];
//    weeksVc.pagerObj = [DMPagerNavigationBarItem newItemWithText: [[NSAttributedString alloc] initWithString:@"SEMANA" attributes:textAttributes]
//                                                     andIcon: [UIImage imageNamed:@"week-icon"]];
//    weeksVc.pagerItem.renderingMode = DMPagerNavigationBarItemModeOnlyImage;
//    
//    TECHistoryMonthsViewController *monthsVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"monthsHistoryController"];
//    monthsVc.pagerObj = [DMPagerNavigationBarItem newItemWithText: [[NSAttributedString alloc] initWithString:@"MES" attributes:textAttributes]
//                                                     andIcon: [UIImage imageNamed:@"month-icon"]];
//    
//    monthsVc.pagerObj.renderingMode = DMPagerNavigationBarItemModeOnlyText;
//    
//    // Create pager with items
//    [TECNutreTecCore sharedInstance].pagerController = [[DMPagerViewController alloc] initWithViewControllers: @[daysVc, weeksVc, monthsVc]];
//    //self.pagerController.useNavigationBar = NO;
//    
//    // Setup pager's navigation bar colors
//    UIColor *activeColor = [UIColor colorWithRed:0.000 green:0.235 blue:0.322 alpha:1.000];
//    UIColor *inactiveColor = [UIColor colorWithRed:.84 green:.84 blue:.84 alpha:1.0];
//    
//    [TECNutreTecCore sharedInstance].pagerController.navigationBar.inactiveItemColor = inactiveColor;
//    [TECNutreTecCore sharedInstance].pagerController.navigationBar.activeItemColor = activeColor;
//}

@end
