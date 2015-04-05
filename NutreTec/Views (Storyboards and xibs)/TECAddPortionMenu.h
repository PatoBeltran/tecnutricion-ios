//
//  TECAddPortionMenu.h
//  NutreTec
//
//  Created by Patricio Beltrán on 4/4/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TECAddPortionMenu : UIView
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, weak) UIView *startItem;

- (instancetype)initWithFrame:(CGRect)frame startItem:(UIView *)startItem menuItems:(NSArray *)menuItems;
- (void)expandMenuItems;
- (void)hideMenuItemsWithCompletion:(void (^)())completion;
- (void)hideAndUnselectMenuItemsWithCompletion:(void (^)())completion;
@end
