//
//  UINavigationController+LSInteractiveTransition.h
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPanSwiper.h"

@interface UINavigationController (LSInteractiveTransition)

//所有界面都可以交互式push动画 当设置为NO时，部分界面需要交互式动画需要设置LSTransitionAnimator.canInteractive=YES
@property (nonatomic,assign) BOOL canInteractivePush;
//所有界面都可以交互式pop动画 和上面相同
@property (nonatomic,assign) BOOL canInteractivePop;
@property (nonatomic,strong) LSPanSwiper *swiper;

-(void)openSwiper;

@end
