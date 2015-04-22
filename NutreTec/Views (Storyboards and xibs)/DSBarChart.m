//
//  DSBarChart.m
//  NutreTec
//
//  Created by Patricio Beltrán on 4/22/15.
//  Copyright (c) 2015 Tecnologico de Monterrey. All rights reserved.
//

#import "DSBarChart.h"

@interface DSBarChart()
@property (nonatomic, strong) NSMutableArray *labels;
@end

@implementation DSBarChart

-(DSBarChart *)initWithFrame:(CGRect)frame
                      values:(NSArray *)values
                      colors:(NSArray *)colors
{
    self = [super initWithFrame:frame];
    if (self) {
        _vals = values;
        _colors = colors;
        _labels = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)calculate{
    self.numberOfBars = [self.vals count];
    for (NSNumber *val in self.vals) {
        float iLen = [val floatValue];
        if (iLen > self.maxLen) {
            self.maxLen = iLen;
        }
    }
}

- (void)changeValues:(NSArray *)values {
    self.vals = values;
    
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    self.labels = nil;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    /// Drawing code
    [self calculate];
    float rectWidth = ((float)(rect.size.width - 20.0 - (self.numberOfBars)) / (float)self.numberOfBars);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /// Draw Bars
    for (int barCount = 0; barCount < self.numberOfBars; barCount++) {
        [UIView animateWithDuration:0.4 animations:^{
            UIColor *iColor ;
            float LBL_HEIGHT = 30.0f, iLen, x, heightRatio, height, y;
            
            /// Calculate dimensions
            iLen = [[self.vals objectAtIndex:barCount] floatValue];
            x = (barCount * (rectWidth)) + 10;
            heightRatio = iLen / self.maxLen;
            height = heightRatio * (rect.size.height - 30.0);
            if (height < 0.1f) height = 1.0f;
            y = rect.size.height - height - LBL_HEIGHT;
            
            /// Reference Label.
            UILabel *lblRef = [[UILabel alloc] initWithFrame:CGRectMake(barCount + x, rect.size.height - LBL_HEIGHT, rectWidth, LBL_HEIGHT)];
            lblRef.text = [[self.vals objectAtIndex:barCount] stringValue];
            lblRef.adjustsFontSizeToFitWidth = YES;
            lblRef.textColor = [UIColor colorWithRed:185./255 green:185./255 blue:185./255 alpha:1.0];
            [lblRef setTextAlignment:NSTextAlignmentCenter];
            lblRef.backgroundColor = [UIColor clearColor];
            [self addSubview:lblRef];
            [self.labels addObject:lblRef];
            
            /// Set color and draw the bar
            iColor = [self.colors objectAtIndex:barCount];
            CGContextSetFillColorWithColor(context, iColor.CGColor);
            CGRect barRect = CGRectMake(barCount + x, y - 5, rectWidth, height);
            CGContextFillRect(context, barRect);
        }];
    }
}

@end
