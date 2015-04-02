//
//  RMDisplayLabel.m
//  BezierLoaders
//
//  Created by Mahesh on 1/30/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "RMDisplayLabel.h"

@interface RMDisplayLabel()
@property(nonatomic, assign)CGFloat toValue;
@property(nonatomic, assign)CGFloat fromValue;
@end

@implementation RMDisplayLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)updateValue:(CGFloat)value {
    self.toValue = floor(value);
    self.fromValue = [self.text floatValue];
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addUpTimer:) userInfo:nil repeats:YES];
    self.text = [NSString stringWithFormat:@"%i",(int)value];
}

- (void)addUpTimer:(NSTimer *)timer {
    self.fromValue++;
    if((int)self.fromValue > (int)self.toValue) {
        [timer invalidate];
    }
    else {
        self.text = [NSString stringWithFormat:@"%d", (int)self.fromValue];
    }
}

@end
