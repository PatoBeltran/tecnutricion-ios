//
//  LoaderProgressController.m
//  Printoo
//
//  Created by Compean on 01/10/14.
//  Copyright (c) 2014 Icalia Labs. All rights reserved.
//

#import "ILLoaderProgressView.h"
#import "UIViewController+MaryPopin.h"
#import "RMDownloadIndicator.h"

static const NSInteger TECLoaderPadding = 10;

@interface ILLoaderProgressView ()
@property RMDownloadIndicator  *closedIndicator;
@property (nonatomic, assign) BOOL hasBeenSetup;
@end

@implementation ILLoaderProgressView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hasBeenSetup = NO;
    self.currentAmount = 0;
}

- (void)setupProgressIndicator {
    if (!self.hasBeenSetup) {
        self.closedIndicator = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake(0,
                                                                                    TECLoaderPadding/2.0,
                                                                                    self.bounds.size.width - TECLoaderPadding,
                                                                                    self.bounds.size.height - TECLoaderPadding)];
        
        [self.closedIndicator setBackgroundColor:[UIColor clearColor]];
        [self.closedIndicator setStrokeColor:[UIColor clearColor]];
        [self.closedIndicator loadIndicator];
        [self.closedIndicator updateWithTotalAmount:1 finishedAmount:0];
        
        [self addSubview:self.closedIndicator];
        self.hasBeenSetup = YES;
    }
}

- (void)setProgressColor:(UIColor *)progressColor {
    [self.closedIndicator setStrokeColor:progressColor];
    [self.closedIndicator loadIndicator];
    _progressColor = progressColor;
}

- (void)setProgressValue:(CGFloat)value forAmount:(CGFloat)amount {
    self.currentAmount = @(value);
    [self.closedIndicator updateWithTotalAmount:amount finishedAmount:value];
}

@end
