//
//  LSPanSwiper.h
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTransitionAnimator.h"

#define k_Progress_Pan_Pop          0.5     //Pop触发的滑动比例
#define k_Progress_Pan_Push         0.5     //Push触发的滑动比例


@class LSPanSwiper;
@protocol LSPanSwiperDelegate <NSObject>

@optional
//交互动画手势开始
- (UIViewController*)swiperBeginPushToNextController:(LSPanSwiper *)swiper;
//交互动画手势结束
- (void)swiperDidEndPushToNextController:(LSPanSwiper *)swiper;
//默认动画
-(LSTransitionAnimator*)swiperAnimatorForDefaultWithIsPush:(BOOL)isPush;

@end


@interface LSPanSwiper : NSObject

//所有界面都可以交互式push动画 当设置为NO时，部分界面需要交互式动画需要设置LSTransitionAnimator.canInteractive=YES
@property (nonatomic,assign) BOOL canInteractivePush; //默认为NO
//所有界面都可以交互式pop动画 和上面相同
@property (nonatomic,assign) BOOL canInteractivePop;//默认为YES

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
@property (nonatomic,weak) id<LSPanSwiperDelegate> delegate;

@end
