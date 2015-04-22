//
//  TECHistoryDaysViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/20/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECHistoryDaysViewController.h"
#import "ILLoaderProgressView.h"
#import "IQDropDownTextField.h"
#import "TECNutreTecCore.h"
#import "TECUserDiet.h"
#import "TECFoodPortion.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>

@interface TECHistoryDaysViewController () <IQDropDownTextFieldDelegate>
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *vegetablesProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *milkProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *meatProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *sugarProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *peasProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *fruitProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *cerealProgress;
@property (nonatomic, weak) IBOutlet ILLoaderProgressView *fatProgress;
@property (nonatomic, weak) IBOutlet IQDropDownTextField *dayChooser;

@property (nonatomic, strong) TECUserDiet *diet;
@property (strong, nonatomic) TECFoodPortion *vegetablesEaten;
@property (strong, nonatomic) TECFoodPortion *milkEaten;
@property (strong, nonatomic) TECFoodPortion *meatEaten;
@property (strong, nonatomic) TECFoodPortion *sugarEaten;
@property (strong, nonatomic) TECFoodPortion *peasEaten;
@property (strong, nonatomic) TECFoodPortion *fruitEaten;
@property (strong, nonatomic) TECFoodPortion *cerealEaten;
@property (strong, nonatomic) TECFoodPortion *fatEaten;
@end

@implementation TECHistoryDaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupColorsForView];
    [self setProgress];
    self.dayChooser.isOptionalDropDown = NO;
    self.dayChooser.delegate = self;
    [self.dayChooser setItemList:[NSArray arrayWithObjects:@"Lunes, 15 Marzo",@"Martes, 16 Marzo",@"Miercoles, 17 Marzo",@"Jueves, 17 Marzo",@"Viernes, 18 Marzo",@"Sabado, 19 Marzo", nil]];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
    
    [self.view addGestureRecognizer:tapBackground];
    [self.view addGestureRecognizer:swipeDown];
}

- (void)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.vegetablesProgress setupProgressIndicator];
    [self.milkProgress setupProgressIndicator];
    [self.meatProgress setupProgressIndicator];
    [self.sugarProgress setupProgressIndicator];
    [self.peasProgress setupProgressIndicator];
    [self.fruitProgress setupProgressIndicator];
    [self.cerealProgress setupProgressIndicator];
    [self.fatProgress setupProgressIndicator];
    [self setupColorsForView];
    [self setProgress];
}

#pragma mark - Progress modificators

- (void)setProgress {
    [self getValuesFromDB];
    [self.vegetablesProgress setProgressValue:self.vegetablesEaten.consumed forAmount:self.diet.vegetablesAmount];
    [self.milkProgress setProgressValue:self.milkEaten.consumed forAmount:self.diet.milkAmount];
    [self.meatProgress setProgressValue:self.meatEaten.consumed forAmount:self.diet.meatAmount];
    [self.sugarProgress setProgressValue:self.sugarEaten.consumed forAmount:self.diet.sugarAmount];
    [self.peasProgress setProgressValue:self.peasEaten.consumed forAmount:self.diet.peaAmount];
    [self.fruitProgress setProgressValue:self.fruitEaten.consumed forAmount:self.diet.fruitAmount];
    [self.cerealProgress setProgressValue:self.cerealEaten.consumed forAmount:self.diet.cerealAmount];
    [self.fatProgress setProgressValue:self.fatEaten.consumed forAmount:self.diet.fatAmount];
}

- (void)setupColorsForView {
    [self.vegetablesProgress setProgressColor:TECVegetablesColor];
    [self.milkProgress setProgressColor:TECMilkColor];
    [self.meatProgress setProgressColor:TECMeatColor];
    [self.sugarProgress setProgressColor:TECSugarColor];
    [self.peasProgress setProgressColor:TECPeaColor];
    [self.fruitProgress setProgressColor:TECFruitColor];
    [self.cerealProgress setProgressColor:TECCerealColor];
    [self.fatProgress setProgressColor:TECFatColor];
}

- (void)updateProgressForView {
    if (self.vegetablesProgress.currentAmount.integerValue != self.vegetablesEaten.consumed) {
        [self.vegetablesProgress setProgressValue:self.vegetablesEaten.consumed forAmount:self.diet.vegetablesAmount];
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
    if (self.peasProgress.currentAmount.integerValue != self.peasEaten.consumed) {
        [self.peasProgress setProgressValue:self.peasEaten.consumed forAmount:self.diet.peaAmount];
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
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSPredicate *predicateDay = [NSPredicate predicateWithFormat:@"day like %@", [dateFormat stringFromDate:today]];
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

- (void)updateValuesForItem:(NSString *)string {
    self.vegetablesEaten.consumed++;
    self.milkEaten.consumed++;
    self.meatEaten.consumed++;
    self.sugarEaten.consumed++;
    self.peasEaten.consumed++;
    self.fruitEaten.consumed++;
    self.cerealEaten.consumed++;
    self.fatEaten.consumed++;
    [self updateProgressForView];
}

#pragma mark - UITextFieldDelegate

- (void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item {
    [self updateValuesForItem:item];
}

@end
