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

@interface TECReferenceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CCMBorderView *contentWrapper;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (assign, nonatomic) TECReferencePortionType cellType;
@property (strong, nonatomic) UITableView *portionsTable;
@property (assign, nonatomic) BOOL hasUpdatedWidth;

- (void)initTable;
@end
