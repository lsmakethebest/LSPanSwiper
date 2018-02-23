//
//  SecondViewController.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "SecondViewController.h"
#import "LSPanSwiperKit.h"
#import "FirstViewController.h"
#import "PopAnimator2.h"
#import "PushAnimator2.h"

@interface SecondViewController ()<LSPanSwiperDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushAnimator=[PushAnimator2 new];
    self.pushAnimator.canInteractive=YES;
    
    self.popAnimator=[PopAnimator2 new];
    self.popAnimator.canInteractive=NO;
    NSInteger count = self.navigationController.viewControllers.count;
    NSString *name = NSStringFromClass([self class]);
    self.label.text = [NSString stringWithFormat:@"第 %@ 个\n%@",@(count),name];
}


- (IBAction)push:(id)sender {
    FirstViewController *controller = [[FirstViewController alloc] initWithNibName:NSStringFromClass([FirstViewController class]) bundle:nil];
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
    FirstViewController *controller = [[FirstViewController alloc] initWithNibName:NSStringFromClass([FirstViewController class]) bundle:nil];
    return controller;
}
-(void)dealloc
{
    NSLog(@"second销毁");
}


@end
