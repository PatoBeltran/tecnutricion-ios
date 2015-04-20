//
//  TECDietViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/20/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECDietViewController.h"
#import "AppDelegate.h"

@interface TECDietViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *vegetablesAmount;
@property (weak, nonatomic) IBOutlet UITextField *milkAmount;
@property (weak, nonatomic) IBOutlet UITextField *meatAmount;
@property (weak, nonatomic) IBOutlet UITextField *sugarAmount;
@property (weak, nonatomic) IBOutlet UITextField *cerealAmount;
@property (weak, nonatomic) IBOutlet UITextField *peaAmount;
@property (weak, nonatomic) IBOutlet UITextField *fruitAmount;
@property (weak, nonatomic) IBOutlet UITextField *fatAmount;
@property (weak, nonatomic) NSDate *currentDate;
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
    /*
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDiet = [NSEntityDescription entityForName:@"Diet" inManagedObjectContext:context];
    NSFetchRequest *requestDiet = [[NSFetchRequest alloc] init];
    [requestDiet setEntity:entityDiet];
    
    //Sort query to get last entry to table Diet
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fecha" ascending:NO];
    [requestDiet setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error;
    NSArray *matchObjectsDiet = [context executeFetchRequest:requestDiet error:&error];
    
    if(matchObjectsDiet.count != 0){
        NSManagedObject *matchRegister = matchObjectsDiet[0];
        self.vegetablesAmount.text = [matchRegister valueForKey:@"vegetable"];
        self.milkAmount.text = [matchRegister valueForKey:@"milk"];
        self.meatAmount.text = [matchRegister valueForKey:@"meat"];
        self.sugarAmount.text = [matchRegister valueForKey:@"sugar"];
        self.peaAmount.text = [matchRegister valueForKey:@"pea"];
        self.fruitAmount.text = [matchRegister valueForKey:@"fruit"];
        self.cerealAmount.text = [matchRegister valueForKey:@"cereal"];
        self.fatAmount.text = [matchRegister valueForKey:@"fat"];
    }*/
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![TECNutreTecCore dietPopupHasBeenShown]) {
        [self performSelector:@selector(presentPopupController) withObject:nil afterDelay:0.5];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveDietDidClicked:(id)sender {
    if ([self canSave]){
        //@TODO - save to database
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        printf("Creating new diet for today\n");
        NSManagedObject *newDiet = [NSEntityDescription insertNewObjectForEntityForName:@"Diet" inManagedObjectContext:context];

        self.currentDate = [NSDate date];

        [newDiet setValue:[NSNumber numberWithInteger:[self.vegetablesAmount.text integerValue]] forKey:@"vegetable"];
        [newDiet setValue:[NSNumber numberWithInteger:[self.milkAmount.text integerValue]] forKey:@"milk"];
        [newDiet setValue:[NSNumber numberWithInteger:[self.meatAmount.text integerValue]] forKey:@"meat"];
        [newDiet setValue:[NSNumber numberWithInteger:[self.cerealAmount.text integerValue]] forKey:@"cereal"];
        [newDiet setValue:[NSNumber numberWithInteger:[self.sugarAmount.text integerValue]] forKey:@"sugar"];
        [newDiet setValue:[NSNumber numberWithInteger:[self.fatAmount.text integerValue]] forKey:@"fat"];
        [newDiet setValue:[NSNumber numberWithInteger:[self.fruitAmount.text integerValue]] forKey:@"fruit"];
        [newDiet setValue:[NSNumber numberWithInteger:[self.peaAmount.text integerValue]] forKey:@"pea"];
        [newDiet setValue:self.currentDate forKey:@"fecha"];
        [newDiet setValue:@"static" forKey:@"type"];

        NSError *error;
        [context save: &error];
        
        [self.view endEditing:YES];
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
