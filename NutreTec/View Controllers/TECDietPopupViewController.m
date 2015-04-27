//
//  TECDietPopupViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/20/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECDietPopupViewController.h"
#import "UIViewController+MaryPopin.h"
#import "TECNutreTecCore.h"

@implementation TECDietPopupViewController

- (void)CCMPlayNDropViewDidFinishDismissAnimationWithDynamics:(CCMPlayNDropView *)view {
    [TECNutreTecCore setDietPopupHasBeenShown:YES];
    [[TECNutreTecCore sharedInstance].popupDietControllerPresenter dismissCurrentPopinControllerAnimated:YES];
}

@end
