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
#import "NutreTec-Swift.h"

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

@end
