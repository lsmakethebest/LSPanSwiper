//
//  PopCircleAnimator.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "PopCircleAnimator.h"

@implementation PopCircleAnimator
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC= [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];

    //画两个圆路径
    CGRect buttonFrame=CGRectMake(140, 140, 50, 50);
    CGFloat x = MAX(buttonFrame.origin.x, containerView.frame.size.width - buttonFrame.origin.x);
    CGFloat y = MAX(buttonFrame.origin.y, containerView.frame.size.height - buttonFrame.origin.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    
    
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:buttonFrame];
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCycle.CGPath;
        fromVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
   
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    if ([transitionContext transitionWasCancelled])
    {
        NSLog(@"");
        [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    }
    
}
@end


