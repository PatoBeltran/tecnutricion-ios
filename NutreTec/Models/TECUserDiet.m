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

@interface TECUserDiet()
@end

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
    
    if([matchObjectsDiet count] == 0) {
        return nil;
    }
    else {
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
}

+ (instancetype)initFromDateInDatabase:(NSString *)date {
    NSEntityDescription *entityDiet = [NSEntityDescription entityForName:TECDietCoreDataEntityName
                                                  inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date like %@", date];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entityDiet];
    
    NSError *error;
    NSArray *matchObjectsDiet = [[[TECNutreTecCore sharedInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if([matchObjectsDiet count] == 0) {
        return nil;
    }
    else {
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
}

+(instancetype) saveNewDiet:(NSInteger)vegetable meat:(NSInteger)meat milk:(NSInteger)milk cereal:(NSInteger)cereal fat:(NSInteger)fat fruit:(NSInteger)fruit sugar:(NSInteger)sugar pea:(NSInteger)pea {
    NSManagedObject *newDiet = [NSEntityDescription insertNewObjectForEntityForName:@"Diet" inManagedObjectContext:[[TECNutreTecCore sharedInstance] managedObjectContext]];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *currentDate = [dateFormatter stringFromDate:today];
    
    [newDiet setValue:[NSNumber numberWithInteger:milk] forKey:@"milk"];
    [newDiet setValue:[NSNumber numberWithInteger:meat] forKey:@"meat"];
    [newDiet setValue:[NSNumber numberWithInteger:vegetable] forKey:@"vegetable"];
    [newDiet setValue:[NSNumber numberWithInteger:sugar] forKey:@"sugar"];
    [newDiet setValue:[NSNumber numberWithInteger:pea] forKey:@"pea"];
    [newDiet setValue:[NSNumber numberWithInteger:fruit] forKey:@"fruit"];
    [newDiet setValue:[NSNumber numberWithInteger:fat] forKey:@"fat"];
    [newDiet setValue:[NSNumber numberWithInteger:cereal] forKey:@"cereal"];
     
    [newDiet setValue:currentDate forKey:@"date"];
    [newDiet setValue:@"static" forKey:@"type"];
    
    NSError *error;
    [[[TECNutreTecCore sharedInstance] managedObjectContext] save:&error];

    return nil;
}

@end
