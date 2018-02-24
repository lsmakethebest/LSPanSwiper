//
//  LSSpreadPopAnimator.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "LSSpreadPopAnimator.h"
#import "UIViewController+LSInteractiveTransition.h"

@implementation LSSpreadPopAnimator

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

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC= [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];

    //画两个圆路径
    CGRect buttonFrame=fromVC.fromRect;
    CGFloat x = MAX(buttonFrame.origin.x, containerView.frame.size.width - buttonFrame.origin.x);
    CGFloat y = MAX(buttonFrame.origin.y, containerView.frame.size.height - buttonFrame.origin.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    
    
    UIBezierPath *startCycle;
    UIBezierPath *endCycle;
    if (fromVC.isCircle) {
        startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        endCycle =  [UIBezierPath bezierPathWithOvalInRect:buttonFrame];
        
    }else{
        startCycle = [UIBezierPath bezierPathWithRect:toVC.view.frame];
        endCycle =  [UIBezierPath bezierPathWithRect:buttonFrame];
    }
    
    
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
//    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
//    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = [self transitionDuration:transitionContext];
    opacityAnimation.removedOnCompletion=NO;
    opacityAnimation.fillMode=kCAFillModeForwards;
    //配置起始位置（fromeVaue）和终止位置（toValue）
    opacityAnimation.values=@[@1,@1,@1];
    opacityAnimation.keyTimes=@[@0,@0.3,@1];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.removedOnCompletion=NO;
    group.fillMode=kCAFillModeForwards;
    group.animations=@[maskLayerAnimation,opacityAnimation];
    group.duration=[self transitionDuration:transitionContext];
    [group setValue:transitionContext forKey:@"transitionContext"];
    group.delegate=self;
    [maskLayer addAnimation:group forKey:@"path"];
    
    
    
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


