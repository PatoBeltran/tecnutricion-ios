//
//  DSBarChart.h
//  NutreTec
//
//  Created by Patricio Beltrán on 4/22/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSBarChart : UIView
-(DSBarChart * )initWithFrame:(CGRect)frame
                       values:(NSArray *)values
                       colors:(NSArray *)colors;
- (void)changeValues:(NSArray *)values;

@property (atomic) NSInteger numberOfBars;
@property (atomic) float maxLen;
@property (atomic) NSArray* vals;
@property (atomic) NSArray* colors;
@end
