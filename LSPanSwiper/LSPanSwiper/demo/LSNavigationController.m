//
//  LSNavigationController.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "LSNavigationController.h"
#import "LSPanSwiperKit.h"
#import "LSPushAnimator.h"
#import "LSPopAnimator.h"
@interface LSNavigationController ()<LSPanSwiperDelegate>


@end

@implementation LSNavigationController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self openSwiper];
    
}


//-(LSTransitionAnimator *)swiperAnimatorForDefaultWithIsPush:(BOOL)isPush
//{
//    if (isPush) {
//        return [LSPushAnimator new];
//    }else{
//        return  [LSPopAnimator new];
//    }
//}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    [super pushViewController:viewController animated:animated];
}


@end

