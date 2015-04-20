//
//  ViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 3/13/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECMenuViewController.h"
#import "XDKAirMenuController.h"
#import "TECHomeViewController.h"

//@TODO - Fix menu for iphone 4 size

typedef NS_ENUM(NSInteger, PBMenuItem){
    PBMenuItemHome = 0,
    PBMenuItemHowAmIGoing,
    PBMenuItemDiet,
    PBMenuItemReference,
    PBMenuItemBlank,
    PBMenuItemFeedback
};

@interface TECMenuViewController () <XDKAirMenuDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TECMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XDKAirMenuController *menuCtr  = [XDKAirMenuController sharedMenu];
    menuCtr.airDelegate = self;
    
    [self.view addSubview:menuCtr.view];
    [self addChildViewController:menuCtr];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MenuSegue"]) {
        self.tableView = ((UITableViewController*)segue.destinationViewController).tableView;
    }
}

#pragma mark - XDKAirMenuControllerDelegate

- (UITableView*)tableViewForAirMenu:(XDKAirMenuController*)airMenu {
    return self.tableView;
}

- (UIViewController*)airMenu:(XDKAirMenuController*)airMenu viewControllerAtIndexPath:(NSIndexPath*)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewContoller;
    switch (indexPath.row) {
        case PBMenuItemHome:
            viewContoller = [storyboard instantiateViewControllerWithIdentifier:@"home"];
            ((TECHomeViewController *)viewContoller).isFromFeedback = NO;
            break;
        case PBMenuItemHowAmIGoing:
            viewContoller = [storyboard instantiateViewControllerWithIdentifier:@"daysHistoryController"];
            break;
        case PBMenuItemDiet:
            viewContoller = [storyboard instantiateViewControllerWithIdentifier:@"diet"];
            break;
        case PBMenuItemReference:
            viewContoller = [storyboard instantiateViewControllerWithIdentifier:@"reference"];
            break;
        case PBMenuItemFeedback:
            viewContoller = [storyboard instantiateViewControllerWithIdentifier:@"home"];
            ((TECHomeViewController *)viewContoller).isFromFeedback = YES;
            break;
    }
    return viewContoller;
}

- (CGFloat)widthControllerForAirMenu:(XDKAirMenuController *)airMenu {
    return 100.0f;
}

@end
