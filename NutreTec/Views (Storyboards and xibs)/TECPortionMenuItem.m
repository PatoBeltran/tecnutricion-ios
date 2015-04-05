//
//  TECPortionMenuItem.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/4/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECPortionMenuItem.h"

@interface TECPortionMenuItem()

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImageView *showingImage;
@property (nonatomic, assign, readwrite) BOOL selected;
@end

@implementation TECPortionMenuItem

- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage size:(CGSize)size type:(TECPortionType)portionType {
    self = [super init];
    if (self) {
        _normalImage = normalImage;
        _selectedImage = selectedImage;
        _size = size;
        _selected = NO;
        _portionType = portionType;
        
        self.showingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        self.showingImage.image = normalImage;
        [self addSubview:self.showingImage];
        
        UITapGestureRecognizer *selectItemTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(didSelectMenuItem:)];
        
        [self addGestureRecognizer:selectItemTap];
    }
    return self;
}

- (void)toggleSelected {
    [self didSelectMenuItem:nil];
}

- (void)didSelectMenuItem:(UITapGestureRecognizer*)sender {
    if (self.selected) {
        self.selected = NO;
        self.showingImage.image = self.normalImage;
    }
    else {
        self.selected = YES;
        self.showingImage.image = self.selectedImage;
    }
}

@end
