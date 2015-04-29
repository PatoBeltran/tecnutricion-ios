//
//  TECDaySummary.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/22/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECDaySummary.h"
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "TECNutreTecCore.h"
#import "TECUserDiet.h"

static NSString * const TECDaySummaryCoreDataEntityName = @"Day";

@implementation TECDaySummary

- (instancetype)initWithPortionsForVegetable:(TECFoodPortion *)vegetable
                                        milk:(TECFoodPortion *)milk
                                        meat:(TECFoodPortion *)meat
                                       sugar:(TECFoodPortion *)sugar
                                         pea:(TECFoodPortion *)pea
                                       fruit:(TECFoodPortion *)fruit
                                      cereal:(TECFoodPortion *)cereal
                                         fat:(TECFoodPortion *)fat
                                      dietId:(NSString *)dietId
                                 currentDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _vegetable = vegetable;
        _milk = milk;
        _meat = meat;
        _sugar = sugar;
        _pea = pea;
        _fruit = fruit;
        _cereal = cereal;
        _fat = fat;
        _dietId = dietId;
        _date = date;
    }
    return self;
}

+ (instancetype)initFromDatabaseWithDate:(NSDate *)date {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TECDaySummaryCoreDataEntityName
                                              inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day like %@", [TECNutreTecCore GMTStringFromDate:date]];
    
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchObjects = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    
    if([matchObjects count]) {
        NSManagedObject *matchRegister = [matchObjects lastObject];
        TECFoodPortion *vegetablesEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeVegetables
                                                                    consumedAmount:[[matchRegister valueForKey:@"vegetable"] integerValue]];
        TECFoodPortion *milkEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeMilk
                                                              consumedAmount:[[matchRegister valueForKey:@"milk"] integerValue]];
        TECFoodPortion *meatEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeMeat
                                                              consumedAmount:[[matchRegister valueForKey:@"meat"] integerValue]];
        TECFoodPortion *sugarEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeSugar
                                                               consumedAmount:[[matchRegister valueForKey:@"sugar"] integerValue]];
        TECFoodPortion *peasEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypePea
                                                              consumedAmount:[[matchRegister valueForKey:@"pea"] integerValue]];
        TECFoodPortion *fruitEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeFruit
                                                               consumedAmount:[[matchRegister valueForKey:@"fruit"] integerValue]];
        TECFoodPortion *cerealEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeCereal
                                                                consumedAmount:[[matchRegister valueForKey:@"cereal"] integerValue]];
        TECFoodPortion *fatEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeFat
                                                             consumedAmount:[[matchRegister valueForKey:@"fat"] integerValue]];
        
        return [[TECDaySummary alloc] initWithPortionsForVegetable:vegetablesEaten
                                                              milk:milkEaten
                                                              meat:meatEaten
                                                             sugar:sugarEaten
                                                               pea:peasEaten
                                                             fruit:fruitEaten
                                                            cereal:cerealEaten
                                                               fat:fatEaten
                                                            dietId:[matchRegister valueForKey:@"diet"]
                                                       currentDate:date];
    }
    return nil;
}

+ (instancetype)createNewDayWithDate:(NSDate *)date dietId:(NSString *)dietId {
    NSManagedObject *newDiet = [NSEntityDescription insertNewObjectForEntityForName:TECDaySummaryCoreDataEntityName
                                                             inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    [newDiet setValue:@0 forKey:@"vegetable"];
    [newDiet setValue:@0 forKey:@"milk"];
    [newDiet setValue:@0 forKey:@"meat"];
    [newDiet setValue:@0 forKey:@"cereal"];
    [newDiet setValue:@0 forKey:@"sugar"];
    [newDiet setValue:@0 forKey:@"fat"];
    [newDiet setValue:@0 forKey:@"fruit"];
    [newDiet setValue:@0 forKey:@"pea"];
    [newDiet setValue:dietId forKey:@"diet"];
    [newDiet setValue:[TECNutreTecCore GMTStringFromDate:date] forKey:@"day"];
    
    TECFoodPortion *vegetablesEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeVegetables
                                                                consumedAmount:0];
    TECFoodPortion *milkEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeMilk
                                                          consumedAmount:0];
    TECFoodPortion *meatEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeMeat
                                                          consumedAmount:0];
    TECFoodPortion *sugarEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeSugar
                                                           consumedAmount:0];
    TECFoodPortion *peasEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypePea
                                                          consumedAmount:0];
    TECFoodPortion *fruitEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeFruit
                                                           consumedAmount:0];
    TECFoodPortion *cerealEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeCereal
                                                            consumedAmount:0];
    TECFoodPortion *fatEaten = [[TECFoodPortion alloc] initWithFoodType:TECFoodPortionTypeFat
                                                         consumedAmount:0];
    
    return [[TECDaySummary alloc] initWithPortionsForVegetable:vegetablesEaten
                                                          milk:milkEaten
                                                          meat:meatEaten
                                                         sugar:sugarEaten
                                                           pea:peasEaten
                                                         fruit:fruitEaten
                                                        cereal:cerealEaten
                                                           fat:fatEaten
                                                        dietId:dietId
                                                   currentDate:date];
}

- (void)save {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TECDaySummaryCoreDataEntityName inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day like %@", [TECNutreTecCore GMTStringFromDate:self.date]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchObjects = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    if([matchObjects count]) {
        NSManagedObject *modDiet = [matchObjects lastObject];
        [modDiet setValue:[NSNumber numberWithInteger:self.vegetable.consumed] forKey:@"vegetable"];
        [modDiet setValue:[NSNumber numberWithInteger:self.milk.consumed] forKey:@"milk"];
        [modDiet setValue:[NSNumber numberWithInteger:self.meat.consumed] forKey:@"meat"];
        [modDiet setValue:[NSNumber numberWithInteger:self.cereal.consumed] forKey:@"cereal"];
        [modDiet setValue:[NSNumber numberWithInteger:self.sugar.consumed] forKey:@"sugar"];
        [modDiet setValue:[NSNumber numberWithInteger:self.fat.consumed] forKey:@"fat"];
        [modDiet setValue:[NSNumber numberWithInteger:self.fruit.consumed] forKey:@"fruit"];
        [modDiet setValue:[NSNumber numberWithInteger:self.pea.consumed] forKey:@"pea"];
        
        [[[TECNutreTecCore sharedInstance] managedObjectContext] save: &error];
    }
}

- (BOOL)dietAccomplished {
    TECUserDiet *diet = [TECUserDiet initFromIdInDatabase:self.dietId];
    
    return diet &&
    self.vegetable.consumed == diet.vegetablesAmount &&
    self.milk.consumed == diet.milkAmount &&
    self.meat.consumed == diet.meatAmount &&
    self.pea.consumed == diet.peaAmount &&
    self.sugar.consumed == diet.sugarAmount &&
    self.fruit.consumed == diet.fruitAmount &&
    self.fat.consumed == diet.fatAmount &&
    self.cereal.consumed == diet.cerealAmount;
}

- (void)dietChangedWithId:(NSString *)dietId {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TECDaySummaryCoreDataEntityName inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day like %@", [TECNutreTecCore GMTStringFromDate:self.date]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchObjects = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    
    NSManagedObject *modDiet = matchObjects[0];
    [modDiet setValue:dietId forKey:@"diet"];
    [[[TECNutreTecCore sharedInstance] managedObjectContext] save:&error];
}

+ (BOOL)hasHistoryDays {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day"
                                              inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *matchObjects = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];

    return matchObjects.count >= 1;
}

@end
