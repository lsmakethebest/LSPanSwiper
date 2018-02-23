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

@property (nonatomic,assign) BOOL canInteractivePop;
@property (nonatomic,strong) LSPanSwiper *swiper;

-(void)openSwiper;

@end
