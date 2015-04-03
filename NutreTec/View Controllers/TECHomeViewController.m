//
//  TECHomeViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 3/15/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECHomeViewController.h"
#import <MessageUI/MessageUI.h>
#import "ILLoaderProgressView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "TECNutreTecCore.h"
#import "TECFoodPortion.h"
#import "TECUserDiet.h"

@interface TECHomeViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet ILLoaderProgressView *vegetableProgress;
@property (weak, nonatomic) IBOutlet ILLoaderProgressView *milkProgress;
@property (weak, nonatomic) IBOutlet ILLoaderProgressView *meatProgress;
@property (weak, nonatomic) IBOutlet ILLoaderProgressView *sugarProgress;
@property (weak, nonatomic) IBOutlet ILLoaderProgressView *peaProgress;
@property (weak, nonatomic) IBOutlet ILLoaderProgressView *fruitProgress;
@property (weak, nonatomic) IBOutlet ILLoaderProgressView *cerealProgress;
@property (weak, nonatomic) IBOutlet ILLoaderProgressView *fatProgress;

@property (strong, nonatomic) TECUserDiet *diet;
@property (strong, nonatomic) TECFoodPortion *vegetablesEaten;
@property (strong, nonatomic) TECFoodPortion *milkEaten;
@property (strong, nonatomic) TECFoodPortion *meatEaten;
@property (strong, nonatomic) TECFoodPortion *sugarEaten;
@property (strong, nonatomic) TECFoodPortion *peasEaten;
@property (strong, nonatomic) TECFoodPortion *fruitEaten;
@property (strong, nonatomic) TECFoodPortion *cerealEaten;
@property (strong, nonatomic) TECFoodPortion *fatEaten;

@property MFMailComposeViewController *mailComposer;
@end

@implementation TECHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFromFeedback) {
        [self showSendFeeback];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    //@TODO - Commit all changes to the database
}

#pragma mark - Database Interaction

- (void)getValuesFromDB {
    //@TODO - Get values from database and change the hardcoded ones
    self.diet = [[TECUserDiet alloc] initWithVegetables:10
                                                   milk:8
                                                   meat:3
                                                  sugar:8
                                                   peas:12
                                                  fruit:13
                                                 cereal:8
                                                    fat:4];
    
    self.vegetablesEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeVegetables
                                                     consumedAmount:12];
    self.milkEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeMilk
                                               consumedAmount:2];
    self.meatEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeMeat
                                               consumedAmount:2];
    self.sugarEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeSugar
                                                consumedAmount:4];
    self.peasEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypePea
                                               consumedAmount:5];
    self.fruitEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeFruit
                                                consumedAmount:0];
    self.cerealEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeCereal
                                                 consumedAmount:7];
    self.fatEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeFat
                                              consumedAmount:1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.vegetableProgress setupProgressIndicator];
    [self.milkProgress setupProgressIndicator];
    [self.meatProgress setupProgressIndicator];
    [self.sugarProgress setupProgressIndicator];
    [self.peaProgress setupProgressIndicator];
    [self.fruitProgress setupProgressIndicator];
    [self.cerealProgress setupProgressIndicator];
    [self.fatProgress setupProgressIndicator];
    [self setProgress];
}

#pragma mark - Progress modificators

- (void)setProgress {
    [self getValuesFromDB];
    [self setAllProgressForView];
}

- (void)setAllProgressForView {
    [self.vegetableProgress setProgressColor:TECVegetablesColor];
    [self.vegetableProgress setProgressValue:self.vegetablesEaten.consumed forAmount:self.diet.vegetablesAmount];
    [self.milkProgress setProgressColor:TECMilkColor];
    [self.milkProgress setProgressValue:self.milkEaten.consumed forAmount:self.diet.milkAmount];
    [self.meatProgress setProgressColor:TECMeatColor];
    [self.meatProgress setProgressValue:self.meatEaten.consumed forAmount:self.diet.meatAmount];
    [self.sugarProgress setProgressColor:TECSugarColor];
    [self.sugarProgress setProgressValue:self.sugarEaten.consumed forAmount:self.diet.sugarAmount];
    [self.peaProgress setProgressColor:TECPeaColor];
    [self.peaProgress setProgressValue:self.peasEaten.consumed forAmount:self.diet.peaAmount];
    [self.fruitProgress setProgressColor:TECFruitColor];
    [self.fruitProgress setProgressValue:self.fruitEaten.consumed forAmount:self.diet.fruitAmount];
    [self.cerealProgress setProgressColor:TECCerealColor];
    [self.cerealProgress setProgressValue:self.cerealEaten.consumed forAmount:self.diet.cerealAmount];
    [self.fatProgress setProgressColor:TECFatColor];
    [self.fatProgress setProgressValue:self.fatEaten.consumed forAmount:self.diet.fatAmount];
}

#pragma mark - Feedback Actions

- (void)showSendFeeback {
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
    [self dismissViewControllerAnimated:YES completion:^{
        [self setProgress];
    }];
}

@end
