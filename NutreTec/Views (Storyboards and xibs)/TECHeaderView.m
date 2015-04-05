//
//  TECHeaderView.m
//  NutreTec
//
//  Created by Patricio Beltrán on 3/15/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECHeaderView.h"
#import "XDKAirMenuController.h"

@implementation TECHeaderView

- (IBAction)menuDidOpen:(UIButton *)sender {
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened) {
        [menu closeMenuAnimated];
    }
    else {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"XDAirMenuWillOpen" object:nil];
        [menu openMenuAnimated];
    }
}

@end
