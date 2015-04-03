//
//  LoaderProgressController.h
//  Printoo
//
//  Created by Compean on 01/10/14.
//  Copyright (c) 2014 Icalia Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILLoaderProgressView : UIView
@property (nonatomic) UIColor *progressColor;
- (void)setProgressValue:(CGFloat)value forAmount:(CGFloat)amount;
- (void)setupProgressIndicator;
@end
