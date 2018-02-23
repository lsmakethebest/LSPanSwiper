//
//  FirstViewController.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThreeViewController.h"
#import "PushAnimator2.h"
#import "LSPanSwiperKit.h"
#import "PushCircleAnimator.h"
@interface FirstViewController () <LSPanSwiperDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation FirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];


        self.pushAnimator=[PushCircleAnimator new];
        self.pushAnimator.canInteractive=YES;
    

//        self.pushAnimator=[PushAnimator2 new];
//        self.pushAnimator.canInteractive=YES;

    
    
    
    NSInteger count = self.navigationController.viewControllers.count;
    NSString *name = NSStringFromClass([self class]);
    self.label.text = [NSString stringWithFormat:@"第 %@ 个\n%@",@(count),name];
}


#pragma mark -- Button Response --
- (IBAction)push:(id)sender {
    ThreeViewController *controller = [[ThreeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)popToRoot:(id)sender {
    NSInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark -- PanSwiper Delegate --
- (UIViewController *)swiperBeginPushToNextController:(LSPanSwiper *)swiper
{
    SecondViewController *controller = [[SecondViewController alloc] init];
    return controller;
}




@end
