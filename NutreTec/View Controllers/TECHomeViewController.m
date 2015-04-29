//
//  TECHomeViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 3/15/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECHomeViewController.h"
#import <MessageUI/MessageUI.h>
#import <FXBlurView/FXBlurView.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "ILLoaderProgressView.h"
#import "TECNutreTecCore.h"
#import "TECDaySummary.h"
#import "TECUserDiet.h"
#import "TECPortionMenuItem.h"
#import "TECAddPortionMenu.h"

static const CGFloat TECGesturePressDurationTime = 0.6;
static const CGFloat TECGesturePressAllowedMovement = 10;

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

@property (strong, nonatomic) NSDate *today;

@property (weak, nonatomic) IBOutlet UIView *noDietAlertView;
@property (weak, nonatomic) IBOutlet UIView *noDietAlertInner;

@property MFMailComposeViewController *mailComposer;
@property BOOL needsToSetupProgressIndicators;
@end

@implementation TECHomeViewController {
    TECHomeViewController __weak * weakSelf;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    weakSelf = self;
    self.needsToSetupProgressIndicators = YES;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(menuWillOpen) name:@"XDAirMenuWillOpen" object:nil];
    
    if (self.isFromFeedback) {
        [self showSendFeeback];
    }

    //Uncomment this ONLY FOR TESTING
    
    //(Only run once) Generate a diet for testing with certain quantity
//    [self generateTestDiet:4];
    
    //(Only run once) Use to generate dummy entries before today's date with random values
//    [self generateEntriesForThePastDays:10];
    
    self.diet = [TECUserDiet initFromLastDietInDatabase];
    
    if (self.diet) {
        self.noDietAlertView.hidden = YES;
        self.todaysProgress = [TECDaySummary initFromDatabaseWithDate:[NSDate date]];
        
        if(!self.todaysProgress) {
            self.todaysProgress = [TECDaySummary createNewDayWithDate:[NSDate date] dietId:self.diet.dietId];
        }
        else if(![self.diet.dietId isEqualToString:self.todaysProgress.dietId]) {
            [self.todaysProgress dietChangedWithId:self.diet.dietId];
        }
    }
    else {
        self.noDietAlertView.hidden = NO;
        [self.noDietAlertInner.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.noDietAlertInner.layer setShadowOpacity:1.0];
        [self.noDietAlertInner.layer setShadowRadius:8.0];
        [self.noDietAlertInner.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.todaysProgress save];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.needsToSetupProgressIndicators) {
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
        [self setupGesturesForView];
        [self setupColorsForView];
        [self updateProgressForView];
        self.needsToSetupProgressIndicators = NO;
    }
}

#pragma mark - Progress modificators

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

#pragma mark - Progress setup

- (void)setupGesturesForView {
    UILongPressGestureRecognizer *veggieGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decreaseVegetables:)];
    veggieGesture.minimumPressDuration = TECGesturePressDurationTime;
    veggieGesture.allowableMovement = TECGesturePressAllowedMovement;
    [self.vegetableProgress addGestureRecognizer:veggieGesture];
    
    UILongPressGestureRecognizer *milkGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decreaseMilk:)];
    milkGesture.minimumPressDuration = TECGesturePressDurationTime;
    milkGesture.allowableMovement = TECGesturePressAllowedMovement;
    [self.milkProgress addGestureRecognizer:milkGesture];
    
    UILongPressGestureRecognizer *meatGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decreaseMeat:)];
    meatGesture.minimumPressDuration = TECGesturePressDurationTime;
    meatGesture.allowableMovement = TECGesturePressAllowedMovement;
    [self.meatProgress addGestureRecognizer:meatGesture];
    
    UILongPressGestureRecognizer *sugarGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decreaseSugar:)];
    sugarGesture.minimumPressDuration = TECGesturePressDurationTime;
    sugarGesture.allowableMovement = TECGesturePressAllowedMovement;
    [self.sugarProgress addGestureRecognizer:sugarGesture];
    
    UILongPressGestureRecognizer *peaGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decreasePea:)];
    peaGesture.minimumPressDuration = TECGesturePressDurationTime;
    peaGesture.allowableMovement = TECGesturePressAllowedMovement;
    [self.peaProgress addGestureRecognizer:peaGesture];
    
    UILongPressGestureRecognizer *fruitGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decreaseFruit:)];
    fruitGesture.minimumPressDuration = TECGesturePressDurationTime;
    fruitGesture.allowableMovement = TECGesturePressAllowedMovement;
    [self.fruitProgress addGestureRecognizer:fruitGesture];
    
    UILongPressGestureRecognizer *cerealGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decreaseCereal:)];
    cerealGesture.minimumPressDuration = TECGesturePressDurationTime;
    cerealGesture.allowableMovement = TECGesturePressAllowedMovement;
    [self.cerealProgress addGestureRecognizer:cerealGesture];
    
    UILongPressGestureRecognizer *fatGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decreaseFat:)];
    fatGesture.minimumPressDuration = TECGesturePressDurationTime;
    fatGesture.allowableMovement = TECGesturePressAllowedMovement;
    [self.fatProgress addGestureRecognizer:fatGesture];
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
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         weakSelf.blurredView.alpha = 1;
                         weakSelf.checkButtonView.hidden = NO;
                         weakSelf.plusButton.hidden = YES;
                         [weakSelf.scrollView setContentOffset:bottomOffset];
                     }
                     completion:^(BOOL finished) {
                         [weakSelf expandAddPortionMenu];
                     }];
}

- (void)dismissAddPortion:(UITapGestureRecognizer*)sender {
    [self.addPortionMenu hideAndUnselectMenuItemsWithCompletion:^{
        [weakSelf willDismissAddPortion];
    }];
}

- (void)willDismissAddPortion {
    CGPoint topOffset = CGPointMake(0, 0);
    [self.scrollView setContentOffset:topOffset animated:YES];
    [UIView animateWithDuration:0.3
                     animations:^{
                         weakSelf.plusButton.hidden = NO;
                         weakSelf.blurredView.alpha = 0;
                         weakSelf.checkButtonView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf.addPortionMenu removeFromSuperview];
                         [weakSelf.blurredView removeFromSuperview];
                         [weakSelf updateProgressForView];
                     }];
}

- (void)expandAddPortionMenu {
    if(!self.addPortionMenu) {
        CGFloat sizeOfItems = (self.view.frame.size.width/4)*0.67;
        NSMutableArray *menuItems = [[NSMutableArray alloc] init];
        NSArray *objectNames = @[@"vegetables", @"milk", @"meat", @"sugar", @"pea", @"fruit", @"cereal", @"fat"];
        
        for (NSInteger i = 0; i < TECPortionTypeCount; i++) {
            TECPortionMenuItem *item = [[TECPortionMenuItem alloc] initWithNormalImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-circle-icon", objectNames[i]]]
                                                                                       selectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-circle-selected-icon", objectNames[i]]]
                                                                                                size:CGSizeMake(sizeOfItems,sizeOfItems)
                                                                                                type:i];
            [menuItems addObject:item];
        }
        
        self.addPortionMenu = [[TECAddPortionMenu alloc] initWithFrame:self.view.bounds
                                                             startItem:self.checkButtonView
                                                             menuItems:menuItems];
        
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
                default:
                    break;
            }
        }
    }
    [self.addPortionMenu hideMenuItemsWithCompletion:^{
        [weakSelf willDismissAddPortion];
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
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    self.mailComposer = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf updateProgressForView];
    }];
}

#pragma mark - Handle Decrease

- (void)decreasePortionForType:(TECPortionType)portionType {
    switch (portionType) {
        case TECPortionTypeVegetables:
            if (self.todaysProgress.vegetable.consumed > 0) self.todaysProgress.vegetable.consumed--;
            break;
        case TECPortionTypeMilk:
            if (self.todaysProgress.milk.consumed > 0) self.todaysProgress.milk.consumed--;
            break;
        case TECPortionTypeMeat:
            if (self.todaysProgress.meat.consumed > 0) self.todaysProgress.meat.consumed--;
            break;
        case TECPortionTypeSugar:
            if (self.todaysProgress.sugar.consumed > 0) self.todaysProgress.sugar.consumed--;
            break;
        case TECPortionTypePea:
            if (self.todaysProgress.pea.consumed > 0) self.todaysProgress.pea.consumed--;
            break;
        case TECPortionTypeFruit:
            if (self.todaysProgress.fruit.consumed > 0) self.todaysProgress.fruit.consumed--;
            break;
        case TECPortionTypeCereal:
            if (self.todaysProgress.cereal.consumed > 0) self.todaysProgress.cereal.consumed--;
            break;
        case TECPortionTypeFat:
            if (self.todaysProgress.fat.consumed > 0) self.todaysProgress.fat.consumed--;
            break;
        default:
            break;
    }
    [self updateProgressForView];
}

- (void)decreaseVegetables:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self decreasePortionForType:TECPortionTypeVegetables];
    }
}

- (void)decreaseMilk:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self decreasePortionForType:TECPortionTypeMilk];
    }
}

- (void)decreaseMeat:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self decreasePortionForType:TECPortionTypeMeat];
    }
}

- (void)decreaseSugar:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self decreasePortionForType:TECPortionTypeSugar];
    }
}

- (void)decreasePea:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self decreasePortionForType:TECPortionTypePea];
    }
}

- (void)decreaseFruit:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self decreasePortionForType:TECPortionTypeFruit];
    }
}

- (void)decreaseCereal:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self decreasePortionForType:TECPortionTypeCereal];
    }
}

- (void)decreaseFat:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [self decreasePortionForType:TECPortionTypeFat];
    }
}

#pragma mark - Testing Helpers

- (void)generateTestDiet:(NSInteger)quantity {
    NSManagedObject *newDiet = [NSEntityDescription insertNewObjectForEntityForName:@"Diet" inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    [newDiet setValue:[NSNumber numberWithInteger:quantity] forKey:@"vegetable"];
    [newDiet setValue:[NSNumber numberWithInteger:quantity] forKey:@"milk"];
    [newDiet setValue:[NSNumber numberWithInteger:quantity] forKey:@"meat"];
    [newDiet setValue:[NSNumber numberWithInteger:quantity] forKey:@"cereal"];
    [newDiet setValue:[NSNumber numberWithInteger:quantity] forKey:@"sugar"];
    [newDiet setValue:[NSNumber numberWithInteger:quantity] forKey:@"fat"];
    [newDiet setValue:[NSNumber numberWithInteger:quantity] forKey:@"fruit"];
    [newDiet setValue:[NSNumber numberWithInteger:quantity] forKey:@"pea"];
    [newDiet setValue:[TECNutreTecCore dietIdFromDate:[NSDate date]] forKey:@"date"];
    [newDiet setValue:@"static" forKey:@"type"];
    
    NSError *error;
    [[[TECNutreTecCore sharedInstance] managedObjectContext] save:&error];
}

- (void)generateEntriesForThePastDays:(NSInteger)numberOfDays {
    for(NSInteger i=numberOfDays; i>0; i--) {
        NSManagedObject *newDay = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                                                inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
        [newDay setValue:[TECNutreTecCore GMTStringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:-(86400*i)]] forKey:@"day"];
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

@end
