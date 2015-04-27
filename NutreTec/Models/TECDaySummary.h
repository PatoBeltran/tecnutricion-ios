//
//  TECDaySummary.h
//  NutreTec
//
//  Created by Patricio Beltrán on 4/22/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECFoodPortion.h"

@interface TECDaySummary : NSObject
@property (nonatomic, strong) TECFoodPortion *vegetable;
@property (nonatomic, strong) TECFoodPortion *milk;
@property (nonatomic, strong) TECFoodPortion *meat;
@property (nonatomic, strong) TECFoodPortion *sugar;
@property (nonatomic, strong) TECFoodPortion *pea;
@property (nonatomic, strong) TECFoodPortion *fruit;
@property (nonatomic, strong) TECFoodPortion *cereal;
@property (nonatomic, strong) TECFoodPortion *fat;
@property (nonatomic, copy) NSString *dietId;
@property (nonatomic, copy) NSString *date;

- (instancetype)initWithPortionsForVegetable:(TECFoodPortion *)vegetable
                                        milk:(TECFoodPortion *)milk
                                        meat:(TECFoodPortion *)meat
                                       sugar:(TECFoodPortion *)sugar
                                         pea:(TECFoodPortion *)pea
                                       fruit:(TECFoodPortion *)fruit
                                      cereal:(TECFoodPortion *)cereal
                                         fat:(TECFoodPortion *)fat
                                      dietId:(NSString *)dietId
                                 currentDate:(NSString *)date;

+ (instancetype)initFromDatabaseWithDate:(NSString *)date;
+ (instancetype)createNewDayWithDate:(NSString *)date dietId:(NSString *)dietId;
- (void)saveWithDate:(NSString *)date;
- (BOOL)checkIfDietWasMade:(NSString *) date;
- (void)dietChanged:(NSString *)date dietId:(NSString *) dietId;
@end
