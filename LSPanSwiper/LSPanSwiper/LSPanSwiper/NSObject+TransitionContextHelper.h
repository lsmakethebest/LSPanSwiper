//
//  NSObject+TransitionContextHelper.h
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (TransitionContextHelper)

- (UIView *)transition_toView;
- (UIView *)transition_fromView;

- (UIViewController *)transition_toViewController;
- (UIViewController *)transition_fromViewController;

@end


@interface UIView (TransitionShadow)

- (void)addLeftSideShadowWithFading;

@end
