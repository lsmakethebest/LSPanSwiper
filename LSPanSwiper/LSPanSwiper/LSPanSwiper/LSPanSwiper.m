//
//  PanSwiper.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "LSPanSwiper.h"
#import "LSInteractiveTransition.h"
#import "UIViewController+LSInteractiveTransition.h"
#import "LSPushAnimator.h"
#import "LSPopAnimator.h"

typedef NS_ENUM(NSInteger, LSPanSwiperDirection) {
    LSPanSwiperDirectionNone   = 0,
    LSPanSwiperDirectionLeft   = 1,
    LSPanSwiperDirectionRight  = 2,
};

@interface LSPanSwiper () <UINavigationControllerDelegate,LSTransitionAnimatorDelegate,LSPanSwiperDelegate>

@property (weak, readwrite, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;

@property (strong, nonatomic) LSInteractiveTransition *interactionController;
@property (strong, nonatomic) LSTransitionAnimator *animator;
@property (assign, nonatomic) BOOL beginAnimation;      //Default is NO;
@property (nonatomic,assign) LSPanSwiperDirection panDirection;

@end

@implementation LSPanSwiper

- (void)dealloc
{
    [_panRecognizer removeTarget:self action:@selector(handleWithPanGestureRecongizer:)];
    [_navigationController.view removeGestureRecognizer:_panRecognizer];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    NSCParameterAssert(!!navigationController);
    
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        _navigationController.delegate = self;
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIGestureRecognizer *gesture = self.navigationController.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithPanGestureRecongizer:)];;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    self.panRecognizer = popRecognizer;
}


#pragma mark -- 偏移量、速度 --
//偏移量
- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    CGFloat t_x = point.x;
    return t_x;
}

//速度
- (CGFloat)velocityWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint point = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    return point.x;
}

//更新拖拽方向
- (CGFloat)updatePanDirection:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    CGFloat velocity_x = [self velocityWithPanGestureRecongizer:panGestureRecognizer];
    if (velocity_x > 0) {
        _panDirection = LSPanSwiperDirectionRight;
    }else if (velocity_x < 0) {
        _panDirection = LSPanSwiperDirectionLeft;
    }else {
        _panDirection = LSPanSwiperDirectionNone;
    }
    return velocity_x;
}


#pragma mark -- 处理手势
- (void)handleWithPanGestureRecongizer:(UIPanGestureRecognizer *)recognizer{

    CGFloat translation_x = [self translationWithPanGestureRecongizer:recognizer];
    CGFloat progress = translation_x / recognizer.view.bounds.size.width;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self updatePanDirection:recognizer];
        [self panGrBegan:recognizer];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self panGrChanged:recognizer progress:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded||recognizer.state == UIGestureRecognizerStateCancelled) {
        [self panGrEnded:recognizer progress:progress];
    }
}

- (void)panGrBegan:(UIPanGestureRecognizer *)recognizer{
    
      UIViewController *viewController=self.navigationController.viewControllers.lastObject;
    if (_panDirection==LSPanSwiperDirectionLeft) {
        if (!viewController.pushAnimator.canInteractive) {
            return;
        }
        
    }else{
        if (!self.canInteractivePop||(viewController.popAnimator&&!viewController.popAnimator.canInteractive)) {
            return;
        }
    }
    if (self.interactionController==nil) {
        self.interactionController=[LSInteractiveTransition new];
    }
    
    self.beginAnimation=YES;
    if (LSPanSwiperDirectionRight == _panDirection ) {
        //Pop
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (LSPanSwiperDirectionLeft == _panDirection){
        //Push
        UIViewController *nextController = [self nextController];
        if (nextController){
            [self.navigationController pushViewController:nextController animated:YES];
        }
    }
}

- (void)panGrChanged:(UIPanGestureRecognizer *)recognizer progress:(CGFloat)progress
{
    if (!self.beginAnimation) {
        return;
    }
    NSLog(@"progress:%lf",progress);
    if (_panDirection==LSPanSwiperDirectionLeft) {
        if (progress>0) {
            progress=0;
        }else{
            progress=ABS(progress);
        }
    }else{
        
    }
    CGFloat panPop_progress = MIN(1.0, MAX(0.0, progress));
    [self.interactionController updateInteractiveTransition:panPop_progress];

}


- (void)panGrEnded:(UIPanGestureRecognizer *)recognizer progress:(CGFloat)progress
{
    if (!self.beginAnimation) {
        return;
    }
    self.beginAnimation=NO;
    
    CGFloat final_progress = 0.0;
    CGFloat k_Default = 0.0;
    if (_panDirection==LSPanSwiperDirectionLeft) {
        CGFloat temp_progress = ABS(progress);
        CGFloat panPush_progress = MIN(1.0, MAX(0.0, temp_progress));
        if (progress > 0) {
            panPush_progress = 0.0f;
        }
        final_progress = panPush_progress;
        k_Default = k_Progress_Pan_Push;
    }
    else {
        CGFloat panPop_progress = MIN(1.0, MAX(0.0, progress));
        final_progress = panPop_progress;
        k_Default = k_Progress_Pan_Pop;
    }
    if (final_progress > k_Default) {
        [self.interactionController finishInteractiveTransition];
    }
    else {
        [self.interactionController cancelInteractiveTransition];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(swiperDidEndPushToNextController:)]) {
        [self.delegate swiperDidEndPushToNextController:self];
    }
}

- (UIViewController *)nextController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(swiperBeginPushToNextController:)]) {
        UIViewController *nextController = [self.delegate swiperBeginPushToNextController:self];
        if (nextController && [nextController isKindOfClass:[UIViewController class]]){
            return nextController;
        }
    }
    return nil;
}

#pragma mark - UINavigationControllerDelegate -

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation==UINavigationControllerOperationPush) {
        if(fromVC.pushAnimator){
            fromVC.pushAnimator.delegate=self;
            self.animator=fromVC.pushAnimator;
            return fromVC.pushAnimator;
        }else{
            self.animator=[self animatorForDefaultWithIsPush:YES];
            if (self.animator) {
                self.animator.delegate=self;
            }
            return self.animator;
            
        }
    }else{
        if(fromVC.popAnimator)
        {
            fromVC.popAnimator.delegate=self;
            self.animator=fromVC.popAnimator;
            return fromVC.popAnimator;
        }else{
            self.animator=[self animatorForDefaultWithIsPush:NO];
            if (self.animator) {
                self.animator.delegate=self;
            }
            return self.animator;
        }
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.beginAnimation&& self.animator.canInteractive) {
        if (self.interactionController==nil) {
        }
        return self.interactionController;
    }
    return nil;
}

-(LSTransitionAnimator*)animatorForDefaultWithIsPush:(BOOL)isPush
{
    if (isPush) {
        LSTransitionAnimator *animator;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(animatorForDefaultWithIsPush:)]) {
            animator=[self.delegate swiperAnimatorForDefaultWithIsPush:YES];
        }
        if (!animator) {
            animator= [LSPushAnimator new];
        }
        return animator;
        
    }else{
        LSTransitionAnimator *animator;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(animatorForDefaultWithIsPush:)]) {
            animator=[self.delegate swiperAnimatorForDefaultWithIsPush:NO];
        }
        if (!animator) {
            animator= [LSPopAnimator new];
            animator.canInteractive=YES;
        }
        return animator;
    }
}

@end

