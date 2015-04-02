//
//  TECUserDiet.h
//  NutreTec
//
//  Created by Patricio Beltrán on 4/2/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TECUserDiet : NSObject
@property (nonatomic, assign) NSInteger vegetablesAmount;
@property (nonatomic, assign) NSInteger milkAmount;
@property (nonatomic, assign) NSInteger meatAmount;
@property (nonatomic, assign) NSInteger sugarAmount;
@property (nonatomic, assign) NSInteger peaAmount;
@property (nonatomic, assign) NSInteger fruitAmount;
@property (nonatomic, assign) NSInteger cerealAmount;
@property (nonatomic, assign) NSInteger fatAmount;

- (instancetype)initWithVegetables:(NSInteger)veggies
                              milk:(NSInteger)milk
                              meat:(NSInteger)meat
                             sugar:(NSInteger)sugar
                              peas:(NSInteger)peas
                             fruit:(NSInteger)fruit
                            cereal:(NSInteger)cereal
                               fat:(NSInteger)fat;
@end
