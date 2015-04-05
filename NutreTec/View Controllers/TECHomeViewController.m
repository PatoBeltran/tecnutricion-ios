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
#import <FXBlurView/FXBlurView.h>
#import "TECPortionMenuItem.h"
#import "TECAddPortionMenu.h"

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

@property (strong, nonatomic) FXBlurView *blurredView;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIView *checkButtonView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) TECAddPortionMenu *addPortionMenu;

@property MFMailComposeViewController *mailComposer;
@end

@implementation TECHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(menuWillOpen) name:@"XDAirMenuWillOpen" object:nil];
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
    [self setupColorsForView];
    [self setProgress];
}

#pragma mark - Progress modificators

- (void)setProgress {
    [self getValuesFromDB];
    [self updateProgressForView];
}

- (void)setupColorsForView {
    [self.vegetableProgress setProgressColor:TECVegetablesColor];
    [self.milkProgress setProgressColor:TECMilkColor];
    [self.meatProgress setProgressColor:TECMeatColor];
    [self.sugarProgress setProgressColor:TECSugarColor];
    [self.peaProgress setProgressColor:TECPeaColor];
    [self.fruitProgress setProgressColor:TECFruitColor];
    [self.cerealProgress setProgressColor:TECCerealColor];
    [self.fatProgress setProgressColor:TECFatColor];
}

- (void)updateProgressForView {
    if (self.vegetableProgress.currentAmount.integerValue != self.vegetablesEaten.consumed) {
        [self.vegetableProgress setProgressValue:self.vegetablesEaten.consumed forAmount:self.diet.vegetablesAmount];
    }
    if (self.milkProgress.currentAmount.integerValue != self.milkEaten.consumed) {
        [self.milkProgress setProgressValue:self.milkEaten.consumed forAmount:self.diet.milkAmount];
    }
    if (self.meatProgress.currentAmount.integerValue != self.meatEaten.consumed) {
        [self.meatProgress setProgressValue:self.meatEaten.consumed forAmount:self.diet.meatAmount];
    }
    if (self.sugarProgress.currentAmount.integerValue != self.sugarEaten.consumed) {
        [self.sugarProgress setProgressValue:self.sugarEaten.consumed forAmount:self.diet.sugarAmount];
    }
    if (self.peaProgress.currentAmount.integerValue != self.peasEaten.consumed) {
        [self.peaProgress setProgressValue:self.peasEaten.consumed forAmount:self.diet.peaAmount];
    }
    if (self.fruitProgress.currentAmount.integerValue != self.fruitEaten.consumed) {
        [self.fruitProgress setProgressValue:self.fruitEaten.consumed forAmount:self.diet.fruitAmount];
    }
    if (self.cerealProgress.currentAmount.integerValue != self.cerealEaten.consumed) {
        [self.cerealProgress setProgressValue:self.cerealEaten.consumed forAmount:self.diet.cerealAmount];
    }
    if (self.fatProgress.currentAmount.integerValue != self.fatEaten.consumed) {
        [self.fatProgress setProgressValue:self.fatEaten.consumed forAmount:self.diet.fatAmount];
    }
}

#pragma mark - Add to current diet

- (IBAction)didClickOnAddToCurrentDiet:(UIButton *)sender {
    if (!self.blurredView) {
        self.blurredView = [[FXBlurView alloc] initWithFrame:self.view.bounds];
        self.blurredView.tintColor = [UIColor clearColor];
        self.blurredView.blurRadius = 15;
        self.blurredView.alpha = 0;
    }
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    
    [self.view insertSubview:self.blurredView belowSubview:self.checkButtonView];
    [UIView animateWithDuration:0.3 animations:^{
        self.blurredView.alpha = 1;
        self.checkButtonView.hidden = NO;
        self.plusButton.hidden = YES;
        [self.scrollView setContentOffset:bottomOffset];
    }
                     completion:^(BOOL finished) {
                         [self expandAddPortionMenu];
                     }];
}

- (void)dismissAddPortion:(UITapGestureRecognizer*)sender {
    [self.addPortionMenu hideAndUnselectMenuItemsWithCompletion:^{
        [self willDismissAddPortion];
    }];
}

- (void)willDismissAddPortion {
    CGPoint topOffset = CGPointMake(0, 0);
    [self.scrollView setContentOffset:topOffset animated:YES];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.plusButton.hidden = NO;
                         self.blurredView.alpha = 0;
                         self.checkButtonView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         [self.addPortionMenu removeFromSuperview];
                         [self.blurredView removeFromSuperview];
                         [self updateProgressForView];
                     }];
}

- (void)expandAddPortionMenu {
    if(!self.addPortionMenu) {
        CGFloat sizeOfItems = (self.view.frame.size.width/4)*0.67;
        TECPortionMenuItem *vegetablesMenuItem = [[TECPortionMenuItem alloc] initWithNormalImage:[UIImage imageNamed:@"vegetables-circle-icon"]
                                                                                   selectedImage:[UIImage imageNamed:@"vegetables-circle-selected-icon"]
                                                                                            size:CGSizeMake(sizeOfItems,sizeOfItems)
                                                                                            type:TECPortionTypeVegetables];
        
        TECPortionMenuItem *milkMenuItem = [[TECPortionMenuItem alloc] initWithNormalImage:[UIImage imageNamed:@"milk-circle-icon"]
                                                                             selectedImage:[UIImage imageNamed:@"milk-circle-selected-icon"]
                                                                                      size:CGSizeMake(sizeOfItems,sizeOfItems)
                                                                                      type:TECPortionTypeMilk];
        
        TECPortionMenuItem *peaMenuItem = [[TECPortionMenuItem alloc] initWithNormalImage:[UIImage imageNamed:@"pea-circle-icon"]
                                                                            selectedImage:[UIImage imageNamed:@"pea-circle-selected-icon"]
                                                                                     size:CGSizeMake(sizeOfItems,sizeOfItems)
                                                                                     type:TECPortionTypePea];
        
        TECPortionMenuItem *cerealMenuItem = [[TECPortionMenuItem alloc] initWithNormalImage:[UIImage imageNamed:@"cereal-circle-icon"]
                                                                               selectedImage:[UIImage imageNamed:@"cereal-circle-selected-icon"]
                                                                                        size:CGSizeMake(sizeOfItems,sizeOfItems)
                                                                                        type:TECPortionTypeCereal];
        
        TECPortionMenuItem *meatMenuItem = [[TECPortionMenuItem alloc] initWithNormalImage:[UIImage imageNamed:@"meat-circle-icon"]
                                                                             selectedImage:[UIImage imageNamed:@"meat-circle-selected-icon"]
                                                                                      size:CGSizeMake(sizeOfItems,sizeOfItems)
                                                                                      type:TECPortionTypeMeat];
        
        TECPortionMenuItem *sugarMenuItem = [[TECPortionMenuItem alloc] initWithNormalImage:[UIImage imageNamed:@"sugar-circle-icon"]
                                                                              selectedImage:[UIImage imageNamed:@"sugar-circle-selected-icon"]
                                                                                       size:CGSizeMake(sizeOfItems,sizeOfItems)
                                                                                       type:TECPortionTypeSugar];
        
        TECPortionMenuItem *fruitMenuItem = [[TECPortionMenuItem alloc] initWithNormalImage:[UIImage imageNamed:@"fruit-circle-icon"]
                                                                              selectedImage:[UIImage imageNamed:@"fruit-circle-selected-icon"]
                                                                                       size:CGSizeMake(sizeOfItems,sizeOfItems)
                                                                                       type:TECPortionTypeFruit];
        
        TECPortionMenuItem *fatMenuItem = [[TECPortionMenuItem alloc] initWithNormalImage:[UIImage imageNamed:@"fat-circle-icon"]
                                                                            selectedImage:[UIImage imageNamed:@"fat-circle-selected-icon"]
                                                                                     size:CGSizeMake(sizeOfItems,sizeOfItems)
                                                                                     type:TECPortionTypeFat];
        
        self.addPortionMenu = [[TECAddPortionMenu alloc] initWithFrame:self.view.bounds
                                                             startItem:self.checkButtonView
                                                             menuItems:@[vegetablesMenuItem, milkMenuItem, meatMenuItem, sugarMenuItem, peaMenuItem, fruitMenuItem, cerealMenuItem, fatMenuItem]];
        
        UITapGestureRecognizer *dismissViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(dismissAddPortion:)];
        
        [self.addPortionMenu addGestureRecognizer:dismissViewTap];
    }
    [self.view insertSubview:self.addPortionMenu belowSubview:self.checkButtonView];
    
    [self.addPortionMenu expandMenuItems];
}
- (IBAction)addCheckDidClicked {
    for (TECPortionMenuItem *item in self.addPortionMenu.menuItems) {
        if (item.selected) {
            switch (item.portionType) {
                case TECPortionTypeVegetables:
                    self.vegetablesEaten.consumed++;
                    break;
                case TECPortionTypeMilk:
                    self.milkEaten.consumed++;
                    break;
                case TECPortionTypeMeat:
                    self.meatEaten.consumed++;
                    break;
                case TECPortionTypeSugar:
                    self.sugarEaten.consumed++;
                    break;
                case TECPortionTypePea:
                    self.peasEaten.consumed++;
                    break;
                case TECPortionTypeFruit:
                    self.fruitEaten.consumed++;
                    break;
                case TECPortionTypeCereal:
                    self.cerealEaten.consumed++;
                    break;
                case TECPortionTypeFat:
                    self.fatEaten.consumed++;
                    break;
            }
        }
    }
    [self.addPortionMenu hideMenuItemsWithCompletion:^{
        [self willDismissAddPortion];
    }];
}

#pragma mark - Manage Notifications 

- (void)menuWillOpen {
    [self dismissAddPortion:nil];
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
