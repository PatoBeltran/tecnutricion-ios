//
//  TECDietViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/20/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECDietViewController.h"
#import "UIViewController+MaryPopin.h"
#import "TECDietPopupViewController.h"
#import "TECNutreTecCore.h"
#import "TecUserDiet.h"

@interface TECDietViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *vegetablesAmount;
@property (weak, nonatomic) IBOutlet UITextField *milkAmount;
@property (weak, nonatomic) IBOutlet UITextField *meatAmount;
@property (weak, nonatomic) IBOutlet UITextField *sugarAmount;
@property (weak, nonatomic) IBOutlet UITextField *cerealAmount;
@property (weak, nonatomic) IBOutlet UITextField *peaAmount;
@property (weak, nonatomic) IBOutlet UITextField *fruitAmount;
@property (weak, nonatomic) IBOutlet UITextField *fatAmount;

@property (strong, nonatomic) TECUserDiet *diet;
@end

@implementation TECDietViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vegetablesAmount.delegate = self;
    self.milkAmount.delegate = self;
    self.meatAmount.delegate = self;
    self.sugarAmount.delegate = self;
    self.cerealAmount.delegate = self;
    self.peaAmount.delegate = self;
    self.fruitAmount.delegate = self;
    self.fatAmount.delegate = self;
    
    self.diet = [TECUserDiet initFromLastDietInDatabase];
    
    if(self.diet){
        [self setDietOnView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![TECNutreTecCore dietPopupHasBeenShown]) {
        [self performSelector:@selector(presentPopupController) withObject:nil afterDelay:0.2];
    }
}

- (void)presentPopupController {
    TECDietPopupViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"dietPopupController"];
    
    [TECNutreTecCore sharedInstance].popupDietControllerPresenter = self;
    [vc setPopinTransitionStyle:BKTPopinTransitionStyleSnap];
    [vc setPopinOptions:BKTPopinDisableAutoDismiss|BKTPopinBlurryDimmingView];
    
    BKTBlurParameters *blurParameters = [BKTBlurParameters new];
    blurParameters.alpha = 0.75f;
    blurParameters.radius = 8.0f;
    blurParameters.tintColor = [UIColor colorWithRed:82./255 green:192./255 blue:202./255 alpha:1];
    
    [vc setBlurParameters:blurParameters];
    [vc setPreferedPopinContentSize:CGSizeMake(280, 300)];
    [vc setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
    [vc setPopinAlignment:BKTPopinAlignementOptionCentered];
    
    [self presentPopinController:vc animated:YES completion:nil];
}

- (IBAction)saveDietDidClicked:(id)sender {
    if ([self canSave]){
        TECUserDiet *diet = [[TECUserDiet alloc] initWithVegetables:[self.vegetablesAmount.text integerValue]
                                                               milk:[self.milkAmount.text integerValue]
                                                               meat:[self.meatAmount.text integerValue]
                                                              sugar:[self.sugarAmount.text integerValue]
                                                               peas:[self.peaAmount.text integerValue]
                                                              fruit:[self.fruitAmount.text integerValue]
                                                             cereal:[self.cerealAmount.text integerValue]
                                                                fat:[self.fatAmount.text integerValue]
                                                             dietId:[TECNutreTecCore dietIdFromDate:[NSDate date]]];
        [diet save];

        [self.view endEditing:YES];
        [[[UIAlertView alloc] initWithTitle:@"¡Perfecto!"
                                    message:@"Tu dieta ha sido grabada exitosamente."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
        
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"¡No estas listo!"
                                    message:@"Primero llena todos los campos."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
    }
}

- (BOOL)canSave {
    return ([self.vegetablesAmount hasText] && [self.milkAmount hasText] && [self.meatAmount hasText] &&
            [self.sugarAmount hasText] && [self.cerealAmount hasText] && [self.peaAmount hasText] &&
            [self.fruitAmount hasText] && [self.fatAmount hasText]);
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.length + range.location > textField.text.length) {
        return NO;
    }
    
    return ([textField.text length] + [string length] - range.length) <= 3;
}

#pragma mark - Helpers

- (void)setDietOnView {
    self.vegetablesAmount.text = [NSString stringWithFormat:@"%ld", self.diet.vegetablesAmount];
    self.milkAmount.text = [NSString stringWithFormat:@"%ld", self.diet.milkAmount];
    self.meatAmount.text = [NSString stringWithFormat:@"%ld", self.diet.meatAmount];
    self.sugarAmount.text = [NSString stringWithFormat:@"%ld", self.diet.sugarAmount];
    self.peaAmount.text = [NSString stringWithFormat:@"%ld", self.diet.peaAmount];
    self.fruitAmount.text = [NSString stringWithFormat:@"%ld", self.diet.fruitAmount];
    self.cerealAmount.text = [NSString stringWithFormat:@"%ld", self.diet.cerealAmount];
    self.fatAmount.text = [NSString stringWithFormat:@"%ld", self.diet.fatAmount];
}

@end
