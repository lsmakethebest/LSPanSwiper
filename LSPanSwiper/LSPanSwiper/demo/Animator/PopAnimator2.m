//  PanPopAnimator2.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//
#import "PopAnimator2.h"

@implementation PopAnimator2

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    [UIView animateWithDuration:0.25 animations:^{
        fromVC.view.transform=CGAffineTransformMakeScale(0.1, 0.1);
    }completion:^(BOOL finished) {
        BOOL didComplete= ![transitionContext transitionWasCancelled];
        
        if (!didComplete) {
            fromVC.view.transform=CGAffineTransformIdentity;
        }else{
            
        }
        [transitionContext completeTransition:didComplete];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(animator:completeWithTransitionFinished:)]) {
            [self.delegate animator:self completeWithTransitionFinished:didComplete];
        }
    }];
}




@end
