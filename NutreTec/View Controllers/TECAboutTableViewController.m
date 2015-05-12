//
//  TECAboutTableViewController.m
//  TecNutricion
//
//  Created by Patricio Beltrán on 5/11/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECAboutTableViewController.h"

@interface TECAboutTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *version;
@end

@implementation TECAboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.version.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

@end
