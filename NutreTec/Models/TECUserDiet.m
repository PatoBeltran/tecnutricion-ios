//
//  TECUserDiet.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/2/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECUserDiet.h"
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "TECNutreTecCore.h"

static NSString * const TECDietCoreDataEntityName = @"Diet";

@implementation TECUserDiet

- (instancetype)initWithVegetables:(NSInteger)veggies milk:(NSInteger)milk meat:(NSInteger)meat sugar:(NSInteger)sugar peas:(NSInteger)peas fruit:(NSInteger)fruit cereal:(NSInteger)cereal fat:(NSInteger)fat dietId:(NSString *)dietId {
    self = [super self];
    if (self) {
        _vegetablesAmount = veggies;
        _milkAmount = milk;
        _meatAmount = meat;
        _sugarAmount = sugar;
        _peaAmount = peas;
        _fruitAmount = fruit;
        _cerealAmount = cereal;
        _fatAmount = fat;
        _dietId = dietId;
    }
    return self;
}

+ (instancetype)initFromLastDietInDatabase {
    NSEntityDescription *entityDiet = [NSEntityDescription entityForName:TECDietCoreDataEntityName
                                                  inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDiet];
    
    NSError *error;
    NSArray *matchObjectsDiet = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if([matchObjectsDiet count]) {
        NSManagedObject *matchRegister = [matchObjectsDiet lastObject];
        return [[TECUserDiet alloc] initWithVegetables:[[matchRegister valueForKey:@"vegetable"] integerValue]
                                                  milk:[[matchRegister valueForKey:@"milk"] integerValue]
                                                  meat:[[matchRegister valueForKey:@"meat"] integerValue]
                                                 sugar:[[matchRegister valueForKey:@"sugar"] integerValue]
                                                  peas:[[matchRegister valueForKey:@"pea"] integerValue]
                                                 fruit:[[matchRegister valueForKey:@"fruit"] integerValue]
                                                cereal:[[matchRegister valueForKey:@"cereal"] integerValue]
                                                   fat:[[matchRegister valueForKey:@"fat"] integerValue]
                                                dietId:[matchRegister valueForKey:@"date"]];
    }
    return nil;
}

+ (instancetype)initFromIdInDatabase:(NSString *)dateId {
    NSEntityDescription *entityDiet = [NSEntityDescription entityForName:TECDietCoreDataEntityName
                                                  inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date like %@", dateId];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entityDiet];
    
    NSError *error;
    NSArray *matchObjectsDiet = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if([matchObjectsDiet count]) {
        NSManagedObject *matchRegister = [matchObjectsDiet lastObject];
        return [[TECUserDiet alloc] initWithVegetables:[[matchRegister valueForKey:@"vegetable"] integerValue]
                                                  milk:[[matchRegister valueForKey:@"milk"] integerValue]
                                                  meat:[[matchRegister valueForKey:@"meat"] integerValue]
                                                 sugar:[[matchRegister valueForKey:@"sugar"] integerValue]
                                                  peas:[[matchRegister valueForKey:@"pea"] integerValue]
                                                 fruit:[[matchRegister valueForKey:@"fruit"] integerValue]
                                                cereal:[[matchRegister valueForKey:@"cereal"] integerValue]
                                                   fat:[[matchRegister valueForKey:@"fat"] integerValue]
                                                dietId:[matchRegister valueForKey:@"date"]];
    }
    return nil;
}

- (void)save {
    NSManagedObject *newDiet = [NSEntityDescription insertNewObjectForEntityForName:TECDietCoreDataEntityName
                                                             inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    [newDiet setValue:[NSNumber numberWithInteger:self.milkAmount] forKey:@"milk"];
    [newDiet setValue:[NSNumber numberWithInteger:self.meatAmount] forKey:@"meat"];
    [newDiet setValue:[NSNumber numberWithInteger:self.vegetablesAmount] forKey:@"vegetable"];
    [newDiet setValue:[NSNumber numberWithInteger:self.sugarAmount] forKey:@"sugar"];
    [newDiet setValue:[NSNumber numberWithInteger:self.peaAmount] forKey:@"pea"];
    [newDiet setValue:[NSNumber numberWithInteger:self.fruitAmount] forKey:@"fruit"];
    [newDiet setValue:[NSNumber numberWithInteger:self.fatAmount] forKey:@"fat"];
    [newDiet setValue:[NSNumber numberWithInteger:self.cerealAmount] forKey:@"cereal"];
     
    [newDiet setValue:self.dietId forKey:@"date"];
    [newDiet setValue:@"static" forKey:@"type"];
    
    NSError *error;
    [[[TECNutreTecCore sharedInstance] managedObjectContext] save:&error];
}

@end
