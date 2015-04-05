//
//  TECPortionMenuItem.h
//  NutreTec
//
//  Created by Patricio Beltrán on 4/4/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TECPortionType) {
    TECPortionTypeVegetables = 0,
    TECPortionTypeMilk,
    TECPortionTypeMeat,
    TECPortionTypeSugar,
    TECPortionTypePea,
    TECPortionTypeFruit,
    TECPortionTypeCereal,
    TECPortionTypeFat
};

@interface TECPortionMenuItem : UIView
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint farPoint;
@property (nonatomic, assign) CGPoint nearPoint;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, assign, readonly) BOOL selected;
@property (nonatomic, assign) TECPortionType portionType;

- (void)toggleSelected;

- (instancetype)initWithNormalImage:(UIImage *)normalImage
                      selectedImage:(UIImage *)selectedImage
                               size:(CGSize)size
                               type:(TECPortionType)portionType;
@end
