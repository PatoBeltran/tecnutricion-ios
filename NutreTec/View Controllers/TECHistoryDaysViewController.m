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
#import "TECDaySummary.h"

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
@property (strong, nonatomic) TECDaySummary *dayProgress;
@property (strong, nonatomic) NSMutableArray *days;
@end

@implementation TECHistoryDaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupColorsForView];
    [self setProgress];
    self.dayChooser.isOptionalDropDown = NO;
    self.dayChooser.delegate = self;
    self.days = [[NSMutableArray alloc] init];
    
    //Generate drop list of past entries
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day"
                                              inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    [request setEntity:entity];
    
    NSError *error;
    NSArray *matchObjects = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    
    if([matchObjects count] == 0) {
        //No diets found
    }
    else {
        NSManagedObject *matchRegister;
        NSString *day;
        for(int i=0; i<matchObjects.count; i++){
            matchRegister = matchObjects[i];
            day = [matchRegister valueForKey:@"day"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"dd/MM/yyyy"];
            NSDate *myDate = [df dateFromString: day];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"EEEE, dd MMMM yyyy"];
            day = [formatter stringFromDate:myDate];
            [self.days addObject:day];
        }
    }
    
    self.diet = [TECUserDiet initFromLastDietInDatabase];
    
    [self.dayChooser setItemList:self.days];
    
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
    //@TODO - you shouldn't get values of today
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    [self getProgressFromDBForDate:[dateFormat stringFromDate:[NSDate date]]];
    
    [self.vegetablesProgress setProgressValue:self.dayProgress.vegetable.consumed forAmount:self.diet.vegetablesAmount];
    [self.milkProgress setProgressValue:self.dayProgress.milk.consumed forAmount:self.diet.milkAmount];
    [self.meatProgress setProgressValue:self.dayProgress.meat.consumed forAmount:self.diet.meatAmount];
    [self.sugarProgress setProgressValue:self.dayProgress.sugar.consumed forAmount:self.diet.sugarAmount];
    [self.peasProgress setProgressValue:self.dayProgress.pea.consumed forAmount:self.diet.peaAmount];
    [self.fruitProgress setProgressValue:self.dayProgress.fruit.consumed forAmount:self.diet.fruitAmount];
    [self.cerealProgress setProgressValue:self.dayProgress.cereal.consumed forAmount:self.diet.cerealAmount];
    [self.fatProgress setProgressValue:self.dayProgress.fat.consumed forAmount:self.diet.fatAmount];
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
    if (self.vegetablesProgress.currentAmount.integerValue != self.dayProgress.vegetable.consumed) {
        [self.vegetablesProgress setProgressValue:self.dayProgress.vegetable.consumed forAmount:self.diet.vegetablesAmount];
    }
    if (self.milkProgress.currentAmount.integerValue != self.dayProgress.milk.consumed) {
        [self.milkProgress setProgressValue:self.dayProgress.milk.consumed forAmount:self.diet.milkAmount];
    }
    if (self.meatProgress.currentAmount.integerValue != self.dayProgress.meat.consumed) {
        [self.meatProgress setProgressValue:self.dayProgress.meat.consumed forAmount:self.diet.meatAmount];
    }
    if (self.sugarProgress.currentAmount.integerValue != self.dayProgress.sugar.consumed) {
        [self.sugarProgress setProgressValue:self.dayProgress.sugar.consumed forAmount:self.diet.sugarAmount];
    }
    if (self.peasProgress.currentAmount.integerValue != self.dayProgress.pea.consumed) {
        [self.peasProgress setProgressValue:self.dayProgress.pea.consumed forAmount:self.diet.peaAmount];
    }
    if (self.fruitProgress.currentAmount.integerValue != self.dayProgress.fruit.consumed) {
        [self.fruitProgress setProgressValue:self.dayProgress.fruit.consumed forAmount:self.diet.fruitAmount];
    }
    if (self.cerealProgress.currentAmount.integerValue != self.dayProgress.cereal.consumed) {
        [self.cerealProgress setProgressValue:self.dayProgress.cereal.consumed forAmount:self.diet.cerealAmount];
    }
    if (self.fatProgress.currentAmount.integerValue != self.dayProgress.fat.consumed) {
        [self.fatProgress setProgressValue:self.dayProgress.fat.consumed forAmount:self.diet.fatAmount];
    }
}

#pragma mark - Database Interaction

- (void)getProgressFromDBForDate:(NSString *)date {
    self.dayProgress = [TECDaySummary initFromDatabaseWithDate:date];
}

- (void)getDietFromDate:(NSString *)date {
    self.diet = [TECUserDiet initFromDateInDatabase:date];
}

- (void)updateValuesForItem:(NSString *)string {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE, dd MMMM yyyy"];
    NSDate *myDate = [df dateFromString: string];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    string = [formatter stringFromDate:myDate];
    [self getProgressFromDBForDate:string];
    [self getDietFromDate:string];
    [self updateProgressForView];
}

#pragma mark - UITextFieldDelegate

- (void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item {
    [self updateValuesForItem:item];
}

@end
