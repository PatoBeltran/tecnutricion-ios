//
//  TECAddPortionMenu.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/4/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "TECAddPortionMenu.h"
#import "TECPortionMenuItem.h"

extern float degreeToRadian(float degree);

@interface TECAddPortionMenu()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL flag;
@end

@implementation TECAddPortionMenu

- (instancetype)initWithFrame:(CGRect)frame startItem:(UIView *)startItem menuItems:(NSArray *)menuItems {
    self = [super initWithFrame:frame];
    if (self) {
        _startItem = startItem;
        _menuItems = menuItems;
        _isAnimating = NO;
        _flag = NO;
    }
    return self;
}

- (void)expandMenuItems {
    [self expandAnimation];
    self.isAnimating = YES;
}

- (void)hideAndUnselectMenuItemsWithCompletion:(void (^)())completion {
    [self unselectAllItems];
    [self closeAnimation];
    self.isAnimating = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        completion();
    });
}

- (void)hideMenuItemsWithCompletion:(void (^)())completion {
    [self closeAnimation];
    self.isAnimating = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self unselectAllItems];
        completion();
    });
}

- (void)unselectAllItems {
    NSInteger count = [self.menuItems count];
    for (int i = 0; i < count; i ++) {
        TECPortionMenuItem *item = [self.menuItems objectAtIndex:i];
        if (item.selected) {
            [item toggleSelected];
        }
    }
}

#pragma mark - animations

- (void)expandAnimation {
    CGPoint startPoint = self.startItem.center;
    CGFloat menuWholeAngle = degreeToRadian(195);
    CGFloat endRadius = self.bounds.size.height * 0.22;
    CGFloat nearRadius = endRadius - 10.0;
    CGFloat farRadius = endRadius + 20.0;
    NSInteger count = [self.menuItems count];
    
    for (int i = 0; i < count; i ++) {
        TECPortionMenuItem *item = [self.menuItems objectAtIndex:i];
        if (!self.flag) {
            item.frame = CGRectMake(startPoint.x, startPoint.y, item.size.width, item.size.height);
            item.tag = 1000 + i;
            item.startPoint = startPoint;
            item.center = item.startPoint;
            
            item.endPoint = CGPointMake(startPoint.x + endRadius * sinf(i * menuWholeAngle / (count - 1) - degreeToRadian(-263)),
                                        startPoint.y - endRadius * cosf(i * menuWholeAngle / (count - 1) - degreeToRadian(-263)));
            
            item.nearPoint = CGPointMake(startPoint.x + nearRadius * sinf(i * menuWholeAngle / (count - 1) - degreeToRadian(-263)),
                                         startPoint.y - nearRadius * cosf(i * menuWholeAngle / (count - 1) - degreeToRadian(-263)));
            
            item.farPoint = CGPointMake(startPoint.x + farRadius * sinf(i * menuWholeAngle / (count - 1) - degreeToRadian(-263)),
                                        startPoint.y - farRadius * cosf(i * menuWholeAngle / (count - 1) - degreeToRadian(-263)));
            [self addSubview:item];
        }
        
        item.hidden = NO;
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI],[NSNumber numberWithFloat:0.0f], nil];
        
        rotateAnimation.duration = 0.3;
        rotateAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.3], [NSNumber numberWithFloat:.4], nil];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 0.3;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
        CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
        animationgroup.duration = 0.3;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animationgroup.delegate = self;
        
        [item.layer addAnimation:animationgroup forKey:@"Expand"];
        item.center = item.endPoint;
    }
    self.flag = YES;
    self.isAnimating = NO;
}

- (void)closeAnimation {
    NSInteger count = [self.menuItems count];
    for (int i = 0; i < count; i ++) {
        [CATransaction begin];
        TECPortionMenuItem *item = (TECPortionMenuItem *)[self viewWithTag:1000 + i];
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2],[NSNumber numberWithFloat:0.0f], nil];
        rotateAnimation.duration = 0.3;
        
        rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:.0],
                                    [NSNumber numberWithFloat:.4],
                                    [NSNumber numberWithFloat:.5], nil];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 0.3;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
        animationgroup.duration = 0.3;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animationgroup.delegate = self;
        [CATransaction setCompletionBlock:^{
            item.hidden = YES;
        }];

        [item.layer addAnimation:animationgroup forKey:@"Close"];
        item.center = item.startPoint;
        [CATransaction commit];
    }
    self.isAnimating = NO;
}

@end
