//
//  TECNutreTecCore.h
//  NutreTec
//
//  Created by Patricio Beltrán on 4/2/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define TECVegetablesColor                  [UIColor colorWithRed:129./255 green:192./255 blue:112./255 alpha:1.0]
#define TECMilkColor                        [UIColor colorWithRed:109./255 green:155./255 blue:188./255 alpha:1.0]
#define TECMeatColor                        [UIColor colorWithRed:151./255 green:106./255 blue:160./255 alpha:1.0]
#define TECSugarColor                       [UIColor colorWithRed:118./255 green:108./255 blue:104./255 alpha:1.0]
#define TECPeaColor                         [UIColor colorWithRed:118./255 green:83./255 blue:121./255 alpha:1.0]
#define TECFruitColor                       [UIColor colorWithRed:196./255 green:87./255 blue:83./255 alpha:1.0]
#define TECCerealColor                      [UIColor colorWithRed:236./255 green:169./255 blue:93./255 alpha:1.0]
#define TECFatColor                         [UIColor colorWithRed:178./255 green:170./255 blue:154./255 alpha:1.0]

#define USER_DEFAULTS_DIET_POPUP_SHOWN    @"diet_popup_shown"

@interface TECNutreTecCore : NSObject
@property BOOL dietPopupHasBeenShown;
@property (weak) UIViewController *popupDietControllerPresenter;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BOOL)dietPopupHasBeenShown;
+ (void)setDietPopupHasBeenShown:(BOOL)flag;
+ (instancetype)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
