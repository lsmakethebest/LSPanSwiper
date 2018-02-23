//
//  NSObject+TransitionContextHelper.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "NSObject+TransitionContextHelper.h"

@implementation NSObject (TransitionContextHelper)

#pragma mark -- UIView --
- (UIView *)transition_toView
{
    return [self _TransitionViewHelper:YES];
}
- (UIView *)transition_fromView
{
    return [self _TransitionViewHelper:NO];
}

- (UIView *)_TransitionViewHelper:(BOOL)isToView
{
    NSAssert([self conformsToProtocol:@protocol(UIViewControllerContextTransitioning)], @"bad parameter");
    if (![self conformsToProtocol:@protocol(UIViewControllerContextTransitioning)]) {
        return nil;
    }
    id<UIViewControllerContextTransitioning> context = (id<UIViewControllerContextTransitioning>)self;
    
    NSString *controllerKey = isToView ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey;
    
    UIViewController *controller = [context viewControllerForKey:controllerKey];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([context respondsToSelector:@selector(viewForKey:)]) {
        NSString *viewKey = isToView ? UITransitionContextToViewKey : UITransitionContextFromViewKey;
        return [context viewForKey:viewKey];
    }
    else {
        return controller.view;
    }
#else
    return controller.view;
#endif
}


#pragma mark -- Controller --
- (UIViewController *)transition_toViewController
{
    return [self _TransitionControllerHelper:YES];
}
- (UIViewController *)transition_fromViewController
{
    return [self _TransitionControllerHelper:NO];
}

- (UIViewController *)_TransitionControllerHelper:(BOOL)isToView
{
    NSAssert([self conformsToProtocol:@protocol(UIViewControllerContextTransitioning)], @"bad parameter");
    if (![self conformsToProtocol:@protocol(UIViewControllerContextTransitioning)]) {
        return nil;
    }
    id<UIViewControllerContextTransitioning> context = (id<UIViewControllerContextTransitioning>)self;
    
    NSString *controllerKey = isToView ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey;
    
    return [context viewControllerForKey:controllerKey];
}

@end



#pragma mark -- TransitionShadow --
@implementation UIView (TransitionShadow)
- (void)addLeftSideShadowWithFading
{
    CGFloat shadowWidth = 4.0f;
    CGFloat shadowVerticalPadding = -1.0f;
    CGFloat shadowHeight = CGRectGetHeight(self.frame) - 2 * shadowVerticalPadding;
    CGRect shadowRect = CGRectMake(-shadowWidth, shadowVerticalPadding, shadowWidth, shadowHeight);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowRect];
    self.layer.shadowPath = [shadowPath CGPath];
    self.layer.shadowOpacity = 0.2f;


    CGFloat toValue = 0.1f;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = @(self.layer.shadowOpacity);
    animation.toValue = @(toValue);
    [self.layer addAnimation:animation forKey:nil];
    self.layer.shadowOpacity = toValue;
}
@end
