//
//  TECReferenceCell.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/5/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECReferenceCell.h"

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
    self.portions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portions" ofType:@"plist"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.portions[self.cellType] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
