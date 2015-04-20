//
//  TECDietViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/20/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECDietViewController.h"

@interface TECDietViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *vegetablesAmount;
@property (weak, nonatomic) IBOutlet UITextField *milkAmount;
@property (weak, nonatomic) IBOutlet UITextField *meatAmount;
@property (weak, nonatomic) IBOutlet UITextField *sugarAmount;
@property (weak, nonatomic) IBOutlet UITextField *cerealAmount;
@property (weak, nonatomic) IBOutlet UITextField *peaAmount;
@property (weak, nonatomic) IBOutlet UITextField *fruitAmount;
@property (weak, nonatomic) IBOutlet UITextField *fatAmount;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveDietDidClicked:(id)sender {
    if ([self canSave]){
        //@TODO - save to database
//        self.vegetablesAmount.text;
//        self.milkAmount.text;
//        self.meatAmount.text;
//        self.sugarAmount.text;
//        self.cerealAmount.text;
//        self.peaAmount.text;
//        self.fruitAmount.text;
//        self.fatAmount.text;
        
        [[[UIAlertView alloc] initWithTitle:@"¡Perfecto!"
                                    message:@"Tu dieta ha sido grabada exitosamente."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
    } else {
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

@end
