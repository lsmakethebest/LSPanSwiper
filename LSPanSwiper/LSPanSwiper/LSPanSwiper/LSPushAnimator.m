//
//  LSPushAnimator.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//
#import "LSPushAnimator.h"

@implementation LSPushAnimator


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{    
    return 0.25;
}
- (void)animateTransition2:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //下一个controller
    UIViewController *nextController = [(NSObject *)transitionContext transition_toViewController];
    //当前controller
    UIViewController *currentController = [(NSObject *)transitionContext transition_fromViewController];
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:nextController.view aboveSubview:currentController.view];
    
    //设置下一个Controller的frame
    nextController.view.frame = [transitionContext finalFrameForViewController:nextController];
    
    //设置动画开始时,nextController的偏移量
    CGFloat nextControllerXTranslation =  CGRectGetWidth(containerView.bounds);
    nextController.view.transform = CGAffineTransformMakeTranslation(nextControllerXTranslation, 0);
    
    //设置左侧阴影
    [nextController.view addLeftSideShadowWithFading];
    
    //黑色蒙层
    UIView *dimmingView = [[UIView alloc] initWithFrame:currentController.view.bounds];
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    dimmingView.alpha = 0.0f;
    [currentController.view addSubview:dimmingView];
    
    BOOL nextClipsToBounds = currentController.view.clipsToBounds;
    nextController.view.clipsToBounds = NO;
    
    
    //TabbarController hidesBottomBarWhenPushed
    UITabBarController *tabBarController = currentController.tabBarController;
    UINavigationController *navController = currentController.navigationController;
    UITabBar *tabBar = tabBarController.tabBar;
    BOOL shouldAddTabBarBackToTabBarController = NO;
    BOOL hidesBottomBarWhenPushed = nextController.hidesBottomBarWhenPushed;
    BOOL tabBarControllerContainsToViewController = [tabBarController.viewControllers containsObject:currentController];
    BOOL tabBarControllerContainsNavController = [tabBarController.viewControllers containsObject:navController];
    BOOL isToViewControllerFirstInNavController = [navController.viewControllers firstObject] == currentController;
    if (hidesBottomBarWhenPushed && tabBar && (tabBarControllerContainsToViewController || (isToViewControllerFirstInNavController && tabBarControllerContainsNavController))) {
        [currentController.view addSubview:tabBar];
        shouldAddTabBarBackToTabBarController = YES;
        tabBar.transform = CGAffineTransformIdentity;
    }
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (shouldAddTabBarBackToTabBarController) {
            CGFloat transform_tabbar = (currentController.view.frame.size.width);
            tabBar.transform = CGAffineTransformMakeTranslation(transform_tabbar, 0);
        }
        
        //设置动画结束时,2个Controller的偏移量 (目标controller必须重置)
        nextController.view.transform = CGAffineTransformIdentity;
        CGFloat transform_tx = - (currentController.view.frame.size.width) * 1.0;
        currentController.view.transform = CGAffineTransformMakeTranslation(transform_tx, 0);
        
        dimmingView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        if (shouldAddTabBarBackToTabBarController) {
            [tabBarController.view addSubview:tabBar];
            tabBar.transform = CGAffineTransformIdentity;
        }
        
        [dimmingView removeFromSuperview];
        //重置2个Controller的偏移量(2个controller都在栈里)
        currentController.view.transform = CGAffineTransformIdentity;
        nextController.view.transform = CGAffineTransformIdentity;
        nextController.view.clipsToBounds = nextClipsToBounds;
        
        BOOL didComplete = ![transitionContext transitionWasCancelled];
        [transitionContext completeTransition:didComplete];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(animator:completeWithTransitionFinished:)]) {
            [self.delegate animator:self completeWithTransitionFinished:didComplete];
        }
    }];
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *toController = [(NSObject *)transitionContext transition_toViewController];
    UIViewController *fromController = [(NSObject *)transitionContext transition_fromViewController];
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toController.view aboveSubview:fromController.view];
    
    //设置下一个Controller的frame
    toController.view.frame = [transitionContext finalFrameForViewController:toController];
    
    //设置动画开始时,nextController的偏移量
    CGFloat nextControllerXTranslation =  CGRectGetWidth(containerView.bounds);
    toController.view.transform = CGAffineTransformMakeTranslation(nextControllerXTranslation, 0);
//    toController.view.frame=CGRectMake(nextControllerXTranslation, 0, CGRectGetWidth(toController.view.frame), CGRectGetHeight(toController.view.frame));
    
    //设置左侧阴影
    [toController.view addLeftSideShadowWithFading];

    //黑色蒙层
    UIView *dimmingView = [[UIView alloc] initWithFrame:fromController.view.bounds];
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    dimmingView.alpha = 0.0f;
    [fromController.view addSubview:dimmingView];

    BOOL nextClipsToBounds = fromController.view.clipsToBounds;
    toController.view.clipsToBounds = NO;

    
    //TabbarController hidesBottomBarWhenPushed
    UITabBarController *tabBarController = fromController.tabBarController;
    UINavigationController *navController = fromController.navigationController;
    UITabBar *tabBar = tabBarController.tabBar;
    
    BOOL shouldAddTabBarBackToTabBarController = NO;
    BOOL hidesBottomBarWhenPushed = toController.hidesBottomBarWhenPushed;
    
    BOOL tabBarControllerContainsToViewController = [tabBarController.viewControllers containsObject:fromController];
    BOOL tabBarControllerContainsNavController = [tabBarController.viewControllers containsObject:navController];
    BOOL isToViewControllerFirstInNavController = [navController.viewControllers firstObject] == fromController;
    if (hidesBottomBarWhenPushed && tabBar && (tabBarControllerContainsToViewController || (isToViewControllerFirstInNavController && tabBarControllerContainsNavController))) {
        [fromController.view addSubview:tabBar];
        shouldAddTabBarBackToTabBarController = YES;
        tabBar.transform = CGAffineTransformIdentity;
    }


    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (shouldAddTabBarBackToTabBarController) {
            CGFloat transform_tabbar = (fromController.view.frame.size.width);
            tabBar.transform = CGAffineTransformMakeTranslation(transform_tabbar, 0);
        }
        
        //设置动画结束时,2个Controller的偏移量 (目标controller必须重置)
        toController.view.transform = CGAffineTransformIdentity;
//         toController.view.frame=CGRectMake(0, 0, CGRectGetWidth(toController.view.frame), CGRectGetHeight(toController.view.frame));
        CGFloat transform_tx = - (fromController.view.frame.size.width) * 1.0;
        fromController.view.transform = CGAffineTransformMakeTranslation(transform_tx, 0);

        dimmingView.alpha = 1.0f;

    } completion:^(BOOL finished) {
        if (shouldAddTabBarBackToTabBarController) {
            [tabBarController.view addSubview:tabBar];
            tabBar.transform = CGAffineTransformIdentity;
        }
        
        [dimmingView removeFromSuperview];
        //重置2个Controller的偏移量(2个controller都在栈里)
        fromController.view.transform = CGAffineTransformIdentity;
        toController.view.transform = CGAffineTransformIdentity;
        toController.view.clipsToBounds = nextClipsToBounds;

        BOOL didComplete = ![transitionContext transitionWasCancelled];
        [transitionContext completeTransition:didComplete];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(animator:completeWithTransitionFinished:)]) {
                [self.delegate animator:self completeWithTransitionFinished:didComplete];
        }
    }];
}

@end
