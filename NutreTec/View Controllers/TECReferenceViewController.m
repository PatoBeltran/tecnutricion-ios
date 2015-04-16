//
//  TECReferenceViewController.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/5/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECReferenceViewController.h"
#import "TECReferenceCell.h"
#import "CCMBorderView.h"

static NSString * const TecReferenceCellIdentifier = @"referenceCell";

@interface TECReferenceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *referenceTable;
@property (nonatomic, strong) NSIndexPath *selectedRowIndex;
@property (nonatomic, assign) CGFloat widthOfCell;
@end

@implementation TECReferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.referenceTable.dataSource = self;
    self.referenceTable.delegate = self;
    self.widthOfCell = -1;
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TECReferenceCell * cell = [tableView dequeueReusableCellWithIdentifier:TecReferenceCellIdentifier];
    
    if (!cell) {
        cell = [[TECReferenceCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:TecReferenceCellIdentifier];
    }
    
    if (self.widthOfCell != -1) {
        CGRect frame = cell.contentWrapper.frame;
        frame.size.width = self.widthOfCell;
        cell.contentWrapper.frame = frame;
        if (!cell.hasUpdatedWidth) {
            [cell.contentWrapper addConstraint:[NSLayoutConstraint constraintWithItem:cell.contentWrapper
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:self.widthOfCell]];
            [cell updateConstraints];
            cell.hasUpdatedWidth = YES;
        }
    }
    
    NSString *titleText;
    UIImage *icon;
    cell.contentWrapper.borderColor = [UIColor colorWithRed:170./255 green:170./255 blue:170./255 alpha:1.0];
    cell.contentWrapper.borderWidth = 1.0;
    switch (indexPath.row) {
        case TECReferencePortionTypeVegetables:
            titleText = @"VEGETALES";
            icon = [UIImage imageNamed:@"vegetables-color-icon"];
            cell.contentWrapper.borderBottom = YES;
            cell.cellType = TECReferencePortionTypeVegetables;
            break;
        case TECReferencePortionTypeMilk:
            titleText = @"LECHE";
            icon = [UIImage imageNamed:@"milk-color-icon"];
            cell.contentWrapper.borderBottom = YES;
            cell.cellType = TECReferencePortionTypeMilk;
            break;
        case TECReferencePortionTypeMeat:
            titleText = @"CARNES";
            icon = [UIImage imageNamed:@"meat-color-icon"];
            cell.contentWrapper.borderBottom = YES;
            cell.cellType = TECReferencePortionTypeMeat;
            break;
        case TECReferencePortionTypeSugar:
            titleText = @"AZÚCARES";
            icon = [UIImage imageNamed:@"sugar-color-icon"];
            cell.contentWrapper.borderBottom = YES;
            cell.cellType = TECReferencePortionTypeSugar;
            break;
        case TECReferencePortionTypePeas:
            titleText = @"LEGUMINOSAS";
            icon = [UIImage imageNamed:@"pea-color-icon"];
            cell.contentWrapper.borderBottom = YES;
            cell.cellType = TECReferencePortionTypePeas;
            break;
        case TECReferencePortionTypeFruit:
            titleText = @"FRUTAS";
            icon = [UIImage imageNamed:@"fruit-color-icon"];
            cell.contentWrapper.borderBottom = YES;
            cell.cellType = TECReferencePortionTypeFruit;
            break;
        case TECReferencePortionTypeCereal:
            titleText = @"CEREALES";
            icon = [UIImage imageNamed:@"cereal-color-icon"];
            cell.contentWrapper.borderBottom = YES;
            cell.cellType = TECReferencePortionTypeCereal;
            break;
        case TECReferencePortionTypeFat:
            titleText = @"GRASAS";
            icon = [UIImage imageNamed:@"fat-color-icon"];
            cell.contentWrapper.borderBottom = NO;
            cell.cellType = TECReferencePortionTypeFat;
            break;
    }
    cell.icon.contentMode = UIViewContentModeScaleAspectFit;
    cell.name.text = titleText;
    cell.name2.text = titleText;
    cell.icon.image = icon;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedRowIndex && indexPath.row == self.selectedRowIndex.row) {
        self.selectedRowIndex = nil;
    }
    else {
        self.selectedRowIndex = indexPath;
    }
    [tableView beginUpdates];
    [tableView endUpdates];
    [tableView scrollToRowAtIndexPath:indexPath
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:NO];
    
    if (self.selectedRowIndex) {
        tableView.scrollEnabled = NO;
        [self updateCellToChangeLayoutWithIndexPath:indexPath open:YES];
    }
    else {
        tableView.scrollEnabled = YES;
        [self updateCellToChangeLayoutWithIndexPath:indexPath open:NO];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectedRowIndex && indexPath.row == self.selectedRowIndex.row) {
        return self.view.bounds.size.height - 85.0;
    }
    return 70;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.widthOfCell == -1) {
        self.widthOfCell = cell.frame.size.width;
        [tableView reloadData];
    }
}

- (void)updateCellToChangeLayoutWithIndexPath:(NSIndexPath *)indexPath open:(BOOL)openCell {
    TECReferenceCell *cell = (TECReferenceCell *)[self.referenceTable cellForRowAtIndexPath:indexPath];
    NSString *cellname;
    switch (indexPath.row) {
        case TECReferencePortionTypeVegetables:
            cellname = @"vegetables";
            break;
        case TECReferencePortionTypeMilk:
            cellname = @"milk";
            break;
        case TECReferencePortionTypeMeat:
            cellname = @"meat";
            break;
        case TECReferencePortionTypeSugar:
            cellname = @"sugar";
            break;
        case TECReferencePortionTypePeas:
            cellname = @"pea";
            break;
        case TECReferencePortionTypeFruit:
            cellname = @"fruit";
            break;
        case TECReferencePortionTypeCereal:
            cellname = @"cereal";
            break;
        case TECReferencePortionTypeFat:
            cellname = @"fat";
            break;
    }
    if (openCell) {
        if(!cell.portionsTable) {
            cell.portionsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, cell.contentWrapper.frame.size.height, self.widthOfCell, self.view.frame.size.height - (cell.contentWrapper.frame.size.height + 85))
                                                              style:UITableViewStylePlain];
            [cell initTable];
        }
        [UIView animateWithDuration:0.3 animations:^{
            cell.contentWrapper.borderWidth = 0;
            CGRect frame = cell.contentWrapper.frame;
            frame.origin.y = 0;
            cell.contentWrapper.frame = frame;
            cell.contentWrapper.backgroundColor = [UIColor colorWithRed:82./255 green:192./255 blue:202./255 alpha:1.0];
            cell.name.alpha = 0;
            cell.selectedView.alpha = 1;
            cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-white-icon", cellname]];
            [cell addSubview:cell.portionsTable];
            [cell.portionsTable reloadData];
        }];
    }
    else {
        [UIView animateWithDuration:0.5 animations:^{
            cell.contentWrapper.borderWidth = 1;
            cell.contentWrapper.backgroundColor = [UIColor clearColor];
            cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-color-icon", cellname]];
            cell.name.alpha = 1;
            cell.selectedView.alpha = 0;
            [cell.portionsTable removeFromSuperview];
        }];
    }
}

@end
