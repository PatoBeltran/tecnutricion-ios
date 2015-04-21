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
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>

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
    
    //Get today's date
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    self.currentDate = [dateFormat stringFromDate:today];
    
    //Initialize for core data
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //Set entity to obtain diet
    NSEntityDescription *entityDiet = [NSEntityDescription entityForName:@"Diet" inManagedObjectContext:context];
    NSFetchRequest *requestDiet = [[NSFetchRequest alloc] init];
    [requestDiet setEntity:entityDiet];
    
    //Entity for day table
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day like %@", self.currentDate];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchObjectsDiet = [context executeFetchRequest:requestDiet error:&error];
    NSArray *matchObjects = [context executeFetchRequest:request error:&error];
    
    if (matchObjectsDiet.count == 0) {
        self.noDietAlertView.hidden = NO;
        [self.noDietAlertInner.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.noDietAlertInner.layer setShadowOpacity:1.0];
        [self.noDietAlertInner.layer setShadowRadius:8.0];
        [self.noDietAlertInner.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
    }
    else {
        self.noDietAlertView.hidden = YES;
        NSManagedObject *matchRegisterDiet = [matchObjectsDiet lastObject];
        //Create new daily diet in case it doesn't exist
        if(matchObjects.count == 0)
        {
            printf("Creating new diet for today\n");
            NSManagedObject *newDiet = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
            
            [newDiet setValue:[NSNumber numberWithInteger:0] forKey:@"vegetable"];
            [newDiet setValue:[NSNumber numberWithInteger:0] forKey:@"milk"];
            [newDiet setValue:[NSNumber numberWithInteger:0] forKey:@"meat"];
            [newDiet setValue:[NSNumber numberWithInteger:0] forKey:@"cereal"];
            [newDiet setValue:[NSNumber numberWithInteger:0] forKey:@"sugar"];
            [newDiet setValue:[NSNumber numberWithInteger:0] forKey:@"fat"];
            [newDiet setValue:[NSNumber numberWithInteger:0] forKey:@"fruit"];
            [newDiet setValue:[NSNumber numberWithInteger:0] forKey:@"pea"];
            [newDiet setValue:[matchRegisterDiet valueForKey:@"fecha"] forKey:@"diet"];
            [newDiet setValue:_currentDate forKey:@"day"];
            
            [context save: &error];
        }
        else {
            //Verify if diet has change
            NSManagedObject *matchRegister = matchObjects[0];
            if(![[matchRegisterDiet valueForKey:@"fecha"] isEqualToString:[matchRegister valueForKey:@"diet"]]) {
                printf("Diet has changed.\n");
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entity];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day like %@", self.currentDate];
                [request setPredicate:predicate];
                
                NSError *error;
                NSArray *matchObjects = [context executeFetchRequest:request error:&error];
                
                NSManagedObject *modDiet = matchObjects[0];
                [modDiet setValue:[matchRegisterDiet valueForKey:@"fecha"] forKey:@"diet"];
                
                [context save: &error];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    //Modify today's entry
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day like %@", self.currentDate];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchObjects = [context executeFetchRequest:request error:&error];
    
    if(matchObjects.count == 0){
        printf("Daily entry not found.\n");
    }
    else
    {
        printf("Saving diet for today\n");
        NSManagedObject *modDiet = matchObjects[0];
        
        [modDiet setValue:[NSNumber numberWithInteger:self.vegetablesEaten.consumed] forKey:@"vegetable"];
        [modDiet setValue:[NSNumber numberWithInteger:self.milkEaten.consumed] forKey:@"milk"];
        [modDiet setValue:[NSNumber numberWithInteger:self.meatEaten.consumed] forKey:@"meat"];
        [modDiet setValue:[NSNumber numberWithInteger:self.cerealEaten.consumed] forKey:@"cereal"];
        [modDiet setValue:[NSNumber numberWithInteger:self.sugarEaten.consumed] forKey:@"sugar"];
        [modDiet setValue:[NSNumber numberWithInteger:self.fatEaten.consumed] forKey:@"fat"];
        [modDiet setValue:[NSNumber numberWithInteger:self.fruitEaten.consumed] forKey:@"fruit"];
        [modDiet setValue:[NSNumber numberWithInteger:self.peasEaten.consumed] forKey:@"pea"];
        
        [context save: &error];
    }

}

#pragma mark - Database Interaction

- (void)getValuesFromDB {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //Load static diet
    NSEntityDescription *entityDiet = [NSEntityDescription entityForName:@"Diet" inManagedObjectContext:context];
    
    NSFetchRequest *requestDiet = [[NSFetchRequest alloc] init];
    [requestDiet setEntity:entityDiet];
    
    NSError *error;
    NSArray *matchObjectsDiet = [context executeFetchRequest:requestDiet error:&error];
    
    if(matchObjectsDiet.count == 0) {
        printf("No diet entry found.\n");
    }
    else {
        printf("Loading static diet.\n");
        NSManagedObject *matchRegister = [matchObjectsDiet lastObject];
        self.diet = [[TECUserDiet alloc] initWithVegetables:[[matchRegister valueForKey:@"vegetable"] integerValue]
                                                       milk:[[matchRegister valueForKey:@"milk"] integerValue]
                                                       meat:[[matchRegister valueForKey:@"meat"] integerValue]
                                                      sugar:[[matchRegister valueForKey:@"sugar"] integerValue]
                                                       peas:[[matchRegister valueForKey:@"pea"] integerValue]
                                                      fruit:[[matchRegister valueForKey:@"fruit"] integerValue]
                                                     cereal:[[matchRegister valueForKey:@"cereal"] integerValue]
                                                        fat:[[matchRegister valueForKey:@"fat"] integerValue]];
    }
    
    //Load current diet (progress)
    NSEntityDescription *entityDay = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
    
    NSFetchRequest *requestDay = [[NSFetchRequest alloc] init];
    [requestDay setEntity:entityDay];
    NSPredicate *predicateDay = [NSPredicate predicateWithFormat:@"day like %@", self.currentDate];
    [requestDay setPredicate:predicateDay];
    
    NSArray *matchObjectsDay = [context executeFetchRequest:requestDay error:&error];
    
    if(matchObjectsDay.count == 0) {
        printf("No daily entry found.\n");
    }
    else {
        printf("Loading diet for today.\n");
        NSManagedObject *matchRegister = matchObjectsDay[0];
        
        self.vegetablesEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeVegetables
                                                         consumedAmount:[[matchRegister valueForKey:@"vegetable"] integerValue]];
        self.milkEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeMilk
                                                   consumedAmount:[[matchRegister valueForKey:@"milk"] integerValue]];
        self.meatEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeMeat
                                                   consumedAmount:[[matchRegister valueForKey:@"meat"] integerValue]];
        self.sugarEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeSugar
                                                    consumedAmount:[[matchRegister valueForKey:@"sugar"] integerValue]];
        self.peasEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypePea
                                                   consumedAmount:[[matchRegister valueForKey:@"pea"] integerValue]];
        self.fruitEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeFruit
                                                    consumedAmount:[[matchRegister valueForKey:@"fruit"] integerValue]];
        self.cerealEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeCereal
                                                     consumedAmount:[[matchRegister valueForKey:@"cereal"] integerValue]];
        self.fatEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeFat
                                                  consumedAmount:[[matchRegister valueForKey:@"fat"] integerValue]];
    }
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
    [self getValuesFromDB];
    [self.vegetableProgress setProgressValue:self.vegetablesEaten.consumed forAmount:self.diet.vegetablesAmount];
    [self.milkProgress setProgressValue:self.milkEaten.consumed forAmount:self.diet.milkAmount];
    [self.meatProgress setProgressValue:self.meatEaten.consumed forAmount:self.diet.meatAmount];
    [self.sugarProgress setProgressValue:self.sugarEaten.consumed forAmount:self.diet.sugarAmount];
    [self.peaProgress setProgressValue:self.peasEaten.consumed forAmount:self.diet.peaAmount];
    [self.fruitProgress setProgressValue:self.fruitEaten.consumed forAmount:self.diet.fruitAmount];
    [self.cerealProgress setProgressValue:self.cerealEaten.consumed forAmount:self.diet.cerealAmount];
    [self.fatProgress setProgressValue:self.fatEaten.consumed forAmount:self.diet.fatAmount];
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
