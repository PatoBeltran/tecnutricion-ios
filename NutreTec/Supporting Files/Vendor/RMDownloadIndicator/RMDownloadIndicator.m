//
//  RMDownloadIndicator.m
//  BezierLoaders
//
//  Created by Mahesh on 1/30/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "RMDownloadIndicator.h"
#import "RMDisplayLabel.h"

@interface RMDownloadIndicator()

/* this contains list of paths to be animated through */
@property(nonatomic, strong)NSMutableArray *paths;

/* the shaper layers used for display */
@property(nonatomic, strong)CAShapeLayer *indicateShapeLayer;
@property(nonatomic, strong)CAShapeLayer *coverLayer;

/* this is the layer used for animation */
@property(nonatomic, strong)CAShapeLayer *animatingLayer;

/* this applies to the covering stroke (default: 2) */
@property(nonatomic, assign)CGFloat coverWidth;

/* the last updatedPath */
@property(nonatomic, strong)UIBezierPath *lastUpdatedPath;
@property(nonatomic, assign)CGFloat lastSourceAngle;

/* this the animation duration (default: 0.5) */
@property(nonatomic, assign)CGFloat animationDuration;

/* this is display label that displays % downloaded */
@property(nonatomic, strong)RMDisplayLabel *displayLabel;

@end

@implementation RMDownloadIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initAttributes];
    }
    return self;
}

- (void)initAttributes {
    // first set the radius percent attribute
    _coverLayer = [CAShapeLayer layer];
    _animatingLayer = _coverLayer;
    
    // set the fill color
    _strokeColor = [UIColor whiteColor];
    _closedIndicatorBackgroundStrokeColor = [UIColor clearColor];
    _coverWidth = 18.0;
    
    [self addDisplayLabel];
    
    _animatingLayer.frame = self.bounds;
    [self.layer addSublayer:_animatingLayer];
    
    // path array
    _paths = [NSMutableArray array];
    
    // animation duration
    _animationDuration = 0.5;
}

- (void)addDisplayLabel {
    self.displayLabel = [[RMDisplayLabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)/2 - 80/2),
                                                                         (CGRectGetHeight(self.bounds)/2 - 30/2),
                                                                         80,
                                                                         30)];
    self.displayLabel.backgroundColor = [UIColor clearColor];
    self.displayLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:27.5];
    self.displayLabel.text = @"0";
    self.displayLabel.textColor = [UIColor colorWithRed:65./255 green:65./255 blue:65./255 alpha:1.0f];
    self.displayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.displayLabel];
}

- (void)loadIndicator {
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIBezierPath *initialPath = [UIBezierPath bezierPath];
    
    [initialPath addArcWithCenter:center
                           radius:(MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
                       startAngle:degreeToRadian(-90)
                         endAngle:degreeToRadian(-90)
                        clockwise:NO];
    
    _animatingLayer.path = initialPath.CGPath;
    _animatingLayer.strokeColor = _strokeColor.CGColor;
    _animatingLayer.fillColor = [UIColor clearColor].CGColor;
    _animatingLayer.lineWidth = _coverWidth - 1.0;
    self.lastSourceAngle = degreeToRadian(-90);
}

#pragma mark - Helper Methods
- (NSArray *)keyframePathsWithDuration:(CGFloat)duration lastUpdatedAngle:(CGFloat)lastUpdatedAngle newAngle:(CGFloat)newAngle radius:(CGFloat)radius {
    NSUInteger frameCount = ceil(duration * 60);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:frameCount + 1];
    for (int frame = 0; frame <= frameCount; frame++) {
        CGFloat startAngle = degreeToRadian(-90);
        
        CGFloat endAngle = lastUpdatedAngle - (((newAngle - lastUpdatedAngle) * frame) / frameCount);
        
        [array addObject:(id)([self pathWithStartAngle:startAngle endAngle:endAngle radius:radius].CGPath)];
    }
    return [NSArray arrayWithArray:array];
}

- (UIBezierPath *)pathWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
    return path;
}

- (void)drawRect:(CGRect)rect {
    CGFloat radius = (MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2) - self.coverWidth;
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    UIBezierPath *innerPath = [UIBezierPath bezierPath];
    [innerPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES]; //add the arc
    [[UIColor colorWithRed:223./255 green:223./255 blue:223./255 alpha:1.0] set];
    [innerPath setLineWidth:1.0];
    [innerPath stroke];
    
    UIBezierPath *outerPath = [UIBezierPath bezierPath];
    [outerPath addArcWithCenter:center radius:radius+self.coverWidth-1.0 startAngle:0 endAngle:2*M_PI clockwise:YES]; //add the arc
    [[UIColor colorWithRed:223./255 green:223./255 blue:223./255 alpha:1.0] set];
    [outerPath setLineWidth:1.0];
    [outerPath stroke];
}

#pragma mark - update indicator
- (void)updateWithTotalAmount:(CGFloat)total finishedAmount:(CGFloat)finished {
    _lastUpdatedPath = [UIBezierPath bezierPathWithCGPath:_animatingLayer.path];
    [_paths removeAllObjects];
    CGFloat ratio;
    if (total <= finished) {
        ratio = 1;
    }
    else {
        ratio = finished/total;
    }
    
    CGFloat destinationAngle = [self destinationAngleForRatio:ratio];
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2 - self.coverWidth/2;
    
    [_paths addObjectsFromArray:[self keyframePathsWithDuration:self.animationDuration
                                               lastUpdatedAngle:self.lastSourceAngle
                                                       newAngle:destinationAngle
                                                         radius:radius]];
    
    _animatingLayer.path = (__bridge CGPathRef)((id)_paths[(_paths.count -1)]);
    self.lastSourceAngle = destinationAngle;
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    [pathAnimation setValues:_paths];
    [pathAnimation setDuration:self.animationDuration];
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [pathAnimation setRemovedOnCompletion:YES];
    [_animatingLayer addAnimation:pathAnimation forKey:@"path"];
    
    if (finished >= total) {
        [self.displayLabel setTextColor:[UIColor colorWithRed:228./255 green:7./255 blue:7./255 alpha:1.0]];
    }
    else {
        [self.displayLabel setTextColor:[UIColor colorWithRed:65./255 green:65./255 blue:65./255 alpha:1.0]];
    }
    
    [self.displayLabel updateValue:finished];
}

- (CGFloat)destinationAngleForRatio:(CGFloat)ratio {
    return degreeToRadian(360*ratio-90);
}

float degreeToRadian(float degree) {
    return ((degree * M_PI)/180.0f);
}

#pragma mark - Setter Methods
- (void)setIndicatorAnimationDuration:(CGFloat)duration {
    self.animationDuration = duration;
}

@end
