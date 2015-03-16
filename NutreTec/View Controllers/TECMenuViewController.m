//
//  ViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 3/13/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECMenuViewController.h"
#import "XDKAirMenuController.h"
#import <MessageUI/MessageUI.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger, PBMenuItem){
    PBMenuItemHome = 0,
    PBMenuItemHowAmIGoing,
    PBMenuItemDiet,
    PBMenuItemReference
};

@interface TECMenuViewController () <XDKAirMenuDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property MFMailComposeViewController *mailComposer;
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
            break;
        case PBMenuItemHowAmIGoing:
            viewContoller = [storyboard instantiateViewControllerWithIdentifier:@"howAmI"];
            break;
        case PBMenuItemDiet:
            viewContoller = [storyboard instantiateViewControllerWithIdentifier:@"diet"];
            break;
        case PBMenuItemReference:
            viewContoller = [storyboard instantiateViewControllerWithIdentifier:@"reference"];
            break;
    }
    return viewContoller;
}

- (CGFloat)widthControllerForAirMenu:(XDKAirMenuController *)airMenu {
    return 100.0f;
}

#pragma mark - Feedback Actions

- (IBAction)feebackButtonDidClicked {
    //@TODO - Change email to actual Nutrition email address
    NSArray *toRecipents = [NSArray arrayWithObject:@"noreply@itesm.mx"];
    self.mailComposer = [[MFMailComposeViewController alloc] init];
    self.mailComposer.mailComposeDelegate = self;
    [self.mailComposer setToRecipients:toRecipents];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self presentViewController:self.mailComposer animated:YES completion:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
    }
    
    self.mailComposer = nil;
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
