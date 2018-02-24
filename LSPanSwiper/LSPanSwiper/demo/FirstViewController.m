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
#import "LSSpreadPushAnimator.h"
@interface FirstViewController () <LSPanSwiperDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button1;

@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation FirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.button1.layer.cornerRadius=54;
    self.button1.clipsToBounds=YES;
    self.pushAnimator=[LSSpreadPushAnimator new];
    self.pushAnimator.canInteractive=NO;//此动画使用CABasicAnimation,在ios11上不支持交互式动画，原因未知
    

//        self.pushAnimator=[PushAnimator2 new];
//        self.pushAnimator.canInteractive=YES;

    
    NSInteger count = self.navigationController.viewControllers.count;
    NSString *name = NSStringFromClass([self class]);
    self.label.text = [NSString stringWithFormat:@"第 %@ 个\n%@",@(count),name];
}


#pragma mark -- Button Response --
- (IBAction)push:(id)sender {
    self.pushAnimator.enabled=YES;
    self.pushAnimator.isCircel=YES;
    self.pushAnimator.fromRect=self.button1.frame;
    SecondViewController *controller = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark -- Button Response --
- (IBAction)push2:(id)sender {
    self.pushAnimator.enabled=YES;
    self.pushAnimator.isCircel=NO;
    self.pushAnimator.fromRect=self.button2.frame;
    SecondViewController *controller = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)push3:(id)sender {
    self.pushAnimator.enabled=NO;
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
