//
//  UIViewController+LSInteractiveTransition.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//


#import "UIViewController+LSInteractiveTransition.h"
#import <objc/runtime.h>
#import "LSTransitionAnimator.h"
#import "UINavigationController+LSInteractiveTransition.h"


@interface UIViewController()<LSPanSwiperDelegate>

@end

@implementation UIViewController (LSInteractiveTransition)

-(void)setPushAnimator:(LSTransitionAnimator *)pushAnimator{
    objc_setAssociatedObject(self, @selector(pushAnimator), pushAnimator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(LSTransitionAnimator *)pushAnimator{
    return  objc_getAssociatedObject(self, _cmd);
}

-(void)setPopAnimator:(LSTransitionAnimator *)popAnimator{
    objc_setAssociatedObject(self, @selector(popAnimator), popAnimator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(LSTransitionAnimator *)popAnimator{
    return  objc_getAssociatedObject(self, _cmd);
}
+(void)load
{
    Class dClass=[self class];
    SEL originalSelector=@selector(viewDidAppear:);
    SEL newSelector=@selector(ls_pan_viewDidAppear:);
    Method originalMethod = class_getInstanceMethod(dClass, originalSelector);
    Method newMethod = class_getInstanceMethod(dClass, newSelector);
    //将 newMethod的实现 添加到系统方法中 也就是说 将 originalMethod方法指针添加成
    //方法newMethod的  返回值表示是否添加成功
    BOOL isAdd = class_addMethod(dClass, originalSelector,
                                 method_getImplementation(newMethod),
                                 method_getTypeEncoding(newMethod));
    //添加成功了 说明 本类中不存在新方法
    //所以此时必须将新方法的实现指针换成原方法的，否则 新方法将没有实现。
    if (isAdd) {
        class_replaceMethod(dClass, newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        //添加失败了 说明本类中 有methodB的实现，此时只需要将
        // originalMethod和newMethod的IMP互换一下即可。
        method_exchangeImplementations(originalMethod, newMethod);
    }
    
}

-(void)ls_pan_viewDidAppear:(BOOL)animated
{
    [self ls_pan_viewDidAppear:animated];
     UINavigationController *nav= self.navigationController;
    if (nav.swiper) {
        nav.swiper.delegate=self;
    }
}
@end





