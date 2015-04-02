//
//  TECUserDiet.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/2/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECUserDiet.h"

@implementation TECUserDiet

- (instancetype)initWithVegetables:(NSInteger)veggies milk:(NSInteger)milk meat:(NSInteger)meat sugar:(NSInteger)sugar peas:(NSInteger)peas fruit:(NSInteger)fruit cereal:(NSInteger)cereal fat:(NSInteger)fat {
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
    }
    return self;
}

@end
