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
#import "TECDaySummary.h"
#import "TECUserDiet.h"
#import <FXBlurView/FXBlurView.h>
#import "TECPortionMenuItem.h"
#import "TECAddPortionMenu.h"
#import <stdlib.h>

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
@property (strong, nonatomic) TECDaySummary *todaysProgress;

@property (strong, nonatomic) FXBlurView *blurredView;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIView *checkButtonView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) TECAddPortionMenu *addPortionMenu;

@property (strong, nonatomic) NSString *currentDate;

@property (weak, nonatomic) IBOutlet UIView *noDietAlertView;
@property (weak, nonatomic) IBOutlet UIView *noDietAlertInner;

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
    
    [self getDietFromDB];
    
    //Use for generating database
    //[self genDB];
    
    NSDate *sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval+3600*5 sinceDate:sourceDate];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    self.currentDate = [dateFormat stringFromDate:destinationDate];
    
    if (!self.diet) {
        self.noDietAlertView.hidden = NO;
        [self.noDietAlertInner.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.noDietAlertInner.layer setShadowOpacity:1.0];
        [self.noDietAlertInner.layer setShadowRadius:8.0];
        [self.noDietAlertInner.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
    }
    else {
        self.noDietAlertView.hidden = YES;
        [self getPortionsFromDB];
        if(!self.todaysProgress) {
            self.todaysProgress = [TECDaySummary createNewDayWithDate:self.currentDate dietId:self.diet.dietId];
        }
        else {
            //Verify if diet has change
            if(![self.diet.dietId isEqualToString:self.todaysProgress.dietId]) {
                [self.todaysProgress dietChanged:self.todaysProgress.date dietId:self.diet.dietId];
            }
        }
    }
}

-(void) genDB {
    
    NSManagedObject *newDiet = [NSEntityDescription insertNewObjectForEntityForName:@"Diet" inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    self.currentDate = [dateFormatter stringFromDate:today];
    
    [newDiet setValue:[NSNumber numberWithInteger:4] forKey:@"vegetable"];
    [newDiet setValue:[NSNumber numberWithInteger:4] forKey:@"milk"];
    [newDiet setValue:[NSNumber numberWithInteger:4] forKey:@"meat"];
    [newDiet setValue:[NSNumber numberWithInteger:4] forKey:@"cereal"];
    [newDiet setValue:[NSNumber numberWithInteger:4] forKey:@"sugar"];
    [newDiet setValue:[NSNumber numberWithInteger:4] forKey:@"fat"];
    [newDiet setValue:[NSNumber numberWithInteger:4] forKey:@"fruit"];
    [newDiet setValue:[NSNumber numberWithInteger:4] forKey:@"pea"];
    [newDiet setValue:self.currentDate forKey:@"fecha"];
    [newDiet setValue:@"static" forKey:@"type"];
    
    NSError *error;
    [[[TECNutreTecCore sharedInstance] managedObjectContext] save:&error];
    
    [self getDietFromDB];
    
    for(int i=10; i>0; i--) {
        NSManagedObject *newDay = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                                                inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
        NSDate *sourceDate = [NSDate date];
        
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        
        NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:-(interval+3600*24*i) sinceDate:sourceDate];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSString *date = [dateFormat stringFromDate:destinationDate];
        
        [newDay setValue:date forKey:@"day"];
        [newDay setValue:[NSNumber numberWithInt:arc4random_uniform(6)] forKey:@"vegetable"];
        [newDay setValue:[NSNumber numberWithInt:arc4random_uniform(6)] forKey:@"meat"];
        [newDay setValue:[NSNumber numberWithInt:arc4random_uniform(6)] forKey:@"milk"];
        [newDay setValue:[NSNumber numberWithInt:arc4random_uniform(6)] forKey:@"fruit"];
        [newDay setValue:[NSNumber numberWithInt:arc4random_uniform(6)] forKey:@"fat"];
        [newDay setValue:[NSNumber numberWithInt:arc4random_uniform(6)] forKey:@"cereal"];
        [newDay setValue:[NSNumber numberWithInt:arc4random_uniform(6)] forKey:@"sugar"];
        [newDay setValue:[NSNumber numberWithInt:arc4random_uniform(6)] forKey:@"pea"];
        [newDay setValue:self.diet.dietId forKey:@"diet"];
        NSError *error;
        [[[TECNutreTecCore sharedInstance] managedObjectContext] save: &error];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.todaysProgress saveWithDate:self.currentDate];
}

#pragma mark - Database Interaction

- (void)getDietFromDB {
    self.diet = [TECUserDiet initFromLastDietInDatabase];
}

- (void)getPortionsFromDB {
    self.todaysProgress = [TECDaySummary initFromDatabaseWithDate:self.currentDate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
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
    [self getPortionsFromDB];
    [self.vegetableProgress setProgressValue:self.todaysProgress.vegetable.consumed forAmount:self.diet.vegetablesAmount];
    [self.milkProgress setProgressValue:self.todaysProgress.milk.consumed forAmount:self.diet.milkAmount];
    [self.meatProgress setProgressValue:self.todaysProgress.meat.consumed forAmount:self.diet.meatAmount];
    [self.sugarProgress setProgressValue:self.todaysProgress.sugar.consumed forAmount:self.diet.sugarAmount];
    [self.peaProgress setProgressValue:self.todaysProgress.pea.consumed forAmount:self.diet.peaAmount];
    [self.fruitProgress setProgressValue:self.todaysProgress.fruit.consumed forAmount:self.diet.fruitAmount];
    [self.cerealProgress setProgressValue:self.todaysProgress.cereal.consumed forAmount:self.diet.cerealAmount];
    [self.fatProgress setProgressValue:self.todaysProgress.fat.consumed forAmount:self.diet.fatAmount];
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
    if (self.vegetableProgress.currentAmount.integerValue != self.todaysProgress.vegetable.consumed) {
        [self.vegetableProgress setProgressValue:self.todaysProgress.vegetable.consumed forAmount:self.diet.vegetablesAmount];
    }
    if (self.milkProgress.currentAmount.integerValue != self.todaysProgress.milk.consumed) {
        [self.milkProgress setProgressValue:self.todaysProgress.milk.consumed forAmount:self.diet.milkAmount];
    }
    if (self.meatProgress.currentAmount.integerValue != self.todaysProgress.meat.consumed) {
        [self.meatProgress setProgressValue:self.todaysProgress.meat.consumed forAmount:self.diet.meatAmount];
    }
    if (self.sugarProgress.currentAmount.integerValue != self.todaysProgress.sugar.consumed) {
        [self.sugarProgress setProgressValue:self.todaysProgress.sugar.consumed forAmount:self.diet.sugarAmount];
    }
    if (self.peaProgress.currentAmount.integerValue != self.todaysProgress.pea.consumed) {
        [self.peaProgress setProgressValue:self.todaysProgress.pea.consumed forAmount:self.diet.peaAmount];
    }
    if (self.fruitProgress.currentAmount.integerValue != self.todaysProgress.fruit.consumed) {
        [self.fruitProgress setProgressValue:self.todaysProgress.fruit.consumed forAmount:self.diet.fruitAmount];
    }
    if (self.cerealProgress.currentAmount.integerValue != self.todaysProgress.cereal.consumed) {
        [self.cerealProgress setProgressValue:self.todaysProgress.cereal.consumed forAmount:self.diet.cerealAmount];
    }
    if (self.fatProgress.currentAmount.integerValue != self.todaysProgress.fat.consumed) {
        [self.fatProgress setProgressValue:self.todaysProgress.fat.consumed forAmount:self.diet.fatAmount];
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
                    self.todaysProgress.vegetable.consumed++;
                    break;
                case TECPortionTypeMilk:
                    self.todaysProgress.milk.consumed++;
                    break;
                case TECPortionTypeMeat:
                    self.todaysProgress.meat.consumed++;
                    break;
                case TECPortionTypeSugar:
                    self.todaysProgress.sugar.consumed++;
                    break;
                case TECPortionTypePea:
                    self.todaysProgress.pea.consumed++;
                    break;
                case TECPortionTypeFruit:
                    self.todaysProgress.fruit.consumed++;
                    break;
                case TECPortionTypeCereal:
                    self.todaysProgress.cereal.consumed++;
                    break;
                case TECPortionTypeFat:
                    self.todaysProgress.fat.consumed++;
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
