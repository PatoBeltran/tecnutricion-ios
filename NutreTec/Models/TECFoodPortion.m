//
//  TECFoodPortion.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/2/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECFoodPortion.h"

@implementation TECFoodPortion

- (instancetype)initWithFoodType:(TECFoodPortionType)foodType consumedAmount:(NSInteger)consumed {
    self = [super init];
    if (self) {
        _foodType = foodType;
        _consumed = consumed;
    }
    return self;
}

@end
