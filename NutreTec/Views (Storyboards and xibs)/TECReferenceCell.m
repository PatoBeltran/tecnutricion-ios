//
//  TECReferenceCell.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/5/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECReferenceCell.h"
#import "TECReferencePortionInnerCell.h"

static NSString * const TECPortionsInnerCellIdentifier = @"portionInnerCell";

@interface TECReferenceCell() <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *portions;
@end

@implementation TECReferenceCell

- (void)awakeFromNib {
    self.hasUpdatedWidth = NO;
}

- (void)initTable {
    self.portionsTable.dataSource = self;
    self.portionsTable.delegate = self;
    self.portionsTable.allowsSelection = NO;
    self.portionsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.portions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portions" ofType:@"plist"]][self.cellTypeName];
    [self.portionsTable registerNib:[UINib nibWithNibName:@"TECReferencePortionInnerCell" bundle:nil] forCellReuseIdentifier:TECPortionsInnerCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.portions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TECReferencePortionInnerCell * cell = [tableView dequeueReusableCellWithIdentifier:TECPortionsInnerCellIdentifier];
    
    if (!cell) {
        cell = [[TECReferencePortionInnerCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:TECPortionsInnerCellIdentifier];
    }
    
    cell.leftLabel.text = self.portions[indexPath.row][@"name"];
    cell.rightLabel.text = self.portions[indexPath.row][@"portion"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
