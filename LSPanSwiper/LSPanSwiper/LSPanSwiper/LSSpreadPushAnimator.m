



//
//  PushCircleAnimator.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "LSSpreadPushAnimator.h"
#import "NSObject+TransitionContextHelper.h"
#import "UIViewController+LSInteractiveTransition.h"
@interface LSSpreadPushAnimator()<CAAnimationDelegate>

@end

@implementation LSSpreadPushAnimator

-(instancetype)init
{
    if (self=[super init]) {
        self.canInteractive=NO;
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];


    //画两个圆路径
    CGRect buttonFrame=self.fromRect;
    CGFloat x = MAX(buttonFrame.origin.x, containerView.frame.size.width - buttonFrame.origin.x);
    CGFloat y = MAX(buttonFrame.origin.y, containerView.frame.size.height - buttonFrame.origin.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));

    UIBezierPath *startCycle;
    UIBezierPath *endCycle;
    if (self.isCircel) {
        startCycle =  [UIBezierPath bezierPathWithOvalInRect:buttonFrame];
        endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
    }else{
        startCycle =  [UIBezierPath bezierPathWithRect:buttonFrame];
        endCycle = [UIBezierPath bezierPathWithRect:toVC.view.frame];
    }
    

    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCycle.CGPath;
    //将maskLayer作为toVC.View的遮盖
    toVC.view.layer.mask = maskLayer;


    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    //动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionLinear];

    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
        id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    
    UIViewController *controller=[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    controller.fromRect=self.fromRect;
    controller.isCircle=self.isCircel;
    
        BOOL didComplete=! [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:didComplete];
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(animator:completeWithTransitionFinished:)]) {
            [self.delegate animator:self completeWithTransitionFinished:didComplete];
        }
}

@end
