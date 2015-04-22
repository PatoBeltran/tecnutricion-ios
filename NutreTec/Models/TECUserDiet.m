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
                                                dietId:[[matchRegister valueForKey:@"fecha"] stringValue]];
    }
}

@end
