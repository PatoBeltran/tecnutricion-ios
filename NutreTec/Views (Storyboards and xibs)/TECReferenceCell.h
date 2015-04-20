//
//  TECReferenceCell.h
//  NutreTec
//
//  Created by Patricio Beltrán on 4/5/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMBorderView.h"

typedef NS_ENUM(NSInteger, TECReferencePortionType){
    TECReferencePortionTypeVegetables = 0,
    TECReferencePortionTypeMilk,
    TECReferencePortionTypeMeat,
    TECReferencePortionTypeSugar,
    TECReferencePortionTypePeas,
    TECReferencePortionTypeFruit,
    TECReferencePortionTypeCereal,
    TECReferencePortionTypeFat
};

static NSString * const TECReferencePortionTypeNameVegetables = @"vegetables";
static NSString * const TECReferencePortionTypeNameMilk = @"milk";
static NSString * const TECReferencePortionTypeNameMeat = @"meat";
static NSString * const TECReferencePortionTypeNameSugar = @"sugar";
static NSString * const TECReferencePortionTypeNamePeas = @"pea";
static NSString * const TECReferencePortionTypeNameFruit = @"fruit";
static NSString * const TECReferencePortionTypeNameCereal = @"cereal";
static NSString * const TECReferencePortionTypeNameFat = @"fat";

@interface TECReferenceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CCMBorderView *contentWrapper;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (assign, nonatomic) TECReferencePortionType cellType;
@property (assign, nonatomic) NSString *cellTypeName;
@property (strong, nonatomic) UITableView *portionsTable;
@property (assign, nonatomic) BOOL hasUpdatedWidth;

- (void)initTable;
@end
