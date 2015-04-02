//
//  TECFoodPortion.h
//  NutreTec
//
//  Created by Patricio Beltrán on 4/2/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TECFoodPortionType){
    TECFoodPortionTypeNone = 0,
    TECFoodPortionTypeVegetables,
    TECFoodPortionTypeMilk,
    TECFoodPortionTypeMeat,
    TECFoodPortionTypeSugar,
    TECFoodPortionTypePea,
    TECFoodPortionTypeFruit,
    TECFoodPortionTypeCereal,
    TECFoodPortionTypeFat
};

@interface TECFoodPortion : NSObject
@property (nonatomic, assign) TECFoodPortionType foodType;
@property (nonatomic, assign) NSInteger consumed;

- (instancetype)initWithFoodType:(TECFoodPortionType)foodType consumedAmount:(NSInteger)consumed;
@end
