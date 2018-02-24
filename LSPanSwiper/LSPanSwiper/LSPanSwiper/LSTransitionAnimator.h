//
//  LSTransitionAnimator.h
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TransitionContextHelper.h"


typedef NS_ENUM(NSInteger, LSTransitionAnimatorType) {
    LSTransitionAnimatorTypePush   = 0,
    LSTransitionAnimatorTypePop   = 1
};

@protocol LSTransitionAnimatorDelegate;


@interface LSTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
//是否支持交互式动画
@property (nonatomic,assign) BOOL canInteractive;
//动画类型
@property (nonatomic,assign) LSTransitionAnimatorType type;
//是否启用 如果为NO则使用系统默认动画
@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,weak) id<LSTransitionAnimatorDelegate> delegate;
//用于push pop缩放动画时 标记来源frame
@property (nonatomic,assign) CGRect fromRect;
//是否是圆形扩散
@property (nonatomic,assign) BOOL isCircel;

@end


@protocol LSTransitionAnimatorDelegate <NSObject>
//动画结束时的回调
- (void)animator:(LSTransitionAnimator *)animator completeWithTransitionFinished:(BOOL)finish;
@end





