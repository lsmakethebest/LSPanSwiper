
//  UINavigationController+LSInteractiveTransition.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//
#import "UINavigationController+LSInteractiveTransition.h"
#import <objc/runtime.h>

@implementation UINavigationController (LSInteractiveTransition)

-(void)setCanInteractivePop:(BOOL)canInteractivePop{
    if (self.swiper) {
        self.swiper.canInteractivePop=canInteractivePop;
    }
}
-(BOOL)canInteractivePop
{
    return  self.swiper.canInteractivePop;
}
-(void)setSwiper:(LSPanSwiper *)swiper
{
    objc_setAssociatedObject(self, @selector(swiper), swiper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(LSPanSwiper *)swiper
{
 return  objc_getAssociatedObject(self, _cmd) ;
    
}

-(void)openSwiper
{
    self.swiper = [[LSPanSwiper alloc] initWithNavigationController:self];
    self.swiper.canInteractivePop=YES;
}


@end
