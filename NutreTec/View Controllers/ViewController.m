//
//  ViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 3/13/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "ViewController.h"
#import <XDKAirMenu/XDKAirMenuController.h>

@interface ViewController () <XDKAirMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XDKAirMenuController *menuCtr  = [XDKAirMenuController sharedMenu];
    menuCtr.airDelegate = self;
    
    [self.view addSubview:menuCtr.view];
    [self addChildViewController:menuCtr];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuDidOpen:(UIButton *)sender {
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened) {
        [menu closeMenuAnimated];
    }
    else {
        [menu openMenuAnimated];
    }
}

- (UITableView*)tableViewForAirMenu:(XDKAirMenuController*)airMenu {
    return nil;
}

- (UIViewController*)airMenu:(XDKAirMenuController*)airMenu viewControllerAtIndexPath:(NSIndexPath*)indexPath {
    return nil;
}

@end
