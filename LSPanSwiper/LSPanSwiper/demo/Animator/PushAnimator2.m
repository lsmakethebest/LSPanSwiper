
//
//  PanPushAnimator2.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "PushAnimator2.h"

@implementation PushAnimator2

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    fromVC.view.frame=containerView.bounds;
    toVC.view.frame=containerView.bounds;
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    toVC.view.transform=CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5 animations:^{
        
        toVC.view.transform=CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        BOOL didComplete=! [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:didComplete];
        if (!didComplete) {
            toVC.view.hidden=YES;
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(animator:completeWithTransitionFinished:)]) {
            [self.delegate animator:self completeWithTransitionFinished:didComplete];
        }
    }];
}



@end
