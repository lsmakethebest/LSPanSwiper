//
//  UIViewController+LSInteractiveTransition.h
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LSTransitionAnimator.h"


@interface UIViewController (LSInteractiveTransition)

//push动画
@property (nonatomic,strong) LSTransitionAnimator *pushAnimator;
//pop动画
@property (nonatomic,strong) LSTransitionAnimator *popAnimator;

@end









