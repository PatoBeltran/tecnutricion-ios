//
//  TECAboutViewController.m
//  TecNutricion
//
//  Created by Patricio Beltrán on 5/11/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECAboutViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MessageUI/MessageUI.h>

@interface TECAboutViewController () <MFMailComposeViewControllerDelegate>
@property MFMailComposeViewController *mailComposer;
@end

@implementation TECAboutViewController{
    TECAboutViewController __weak * weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    weakSelf = self;
}

- (IBAction)sendFeedbackDidCliked:(UIButton *)sender {
    [self showSendFeeback];
}

#pragma mark - Feedback Actions

- (void)showSendFeeback {
    NSArray *toRecipents = [NSArray arrayWithObject:@"tecnutricion.mty@gmail.com"];
    self.mailComposer = [[MFMailComposeViewController alloc] init];
    self.mailComposer.mailComposeDelegate = self;
    [self.mailComposer setToRecipients:toRecipents];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self presentViewController:self.mailComposer animated:YES completion:^{
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    self.mailComposer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
