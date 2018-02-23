# LSPanSwiper
## 几行代码实现交互式push pop动画

### 开启设置只需要在UINavigationController里写以下代码
```
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self openSwiper];
    //self.canInteractive=NO;//所有界面禁用交互式pop动画
}
```
### 默认所有界面都可以交互式pop，默认push,pop动画为系统样式，如果想修改默认动画，在UINavigationController里实现以下代理方法
```
-(LSTransitionAnimator *)swiperAnimatorForDefaultWithIsPush:(BOOL)isPush
{
    if (isPush) {
        return [PushAnimator1 new];//此处PushAnimator1为自己定义的动画
    }else{
        return  [PopAnimator1 new];////此处PopAnimator1为自己定义的动画
    }
}
```

### 如果想禁用所有界面pop交互式动画，则在UINavigationController里

```
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self openSwiper];
    self.canInteractivePop=NO;
}
```


### 如果某个UIViewController想要自定义push动画

```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushAnimator=[PushAnimator2 new];
    self.pushAnimator.canInteractive=YES;//设置为YES则代表打开交互式push

}

```
### 如果自定义了交互式push动画,则需要实现以下代理方法，来告诉需要push哪个VC
```
- (UIViewController *)swiperBeginPushToNextController:(LSPanSwiper *)swiper
{
    SecondViewController *controller = [[SecondViewController alloc] init];
    return controller;
}
```
### 如果某个UIViewController想要自定义pop动画

```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.popAnimator=[PopAnimator2 new];
    self.popAnimator.canInteractive=YES;
    //nav.canInteractive=NO   self.popAnimator.canInteractive=YES;   无交互动画
    //nav.canInteractive=YES   self.popAnimator.canInteractive=YES;  有交互动画
    //nav.canInteractive=YES   self.popAnimator.canInteractive=NO;   无交互动画
}
```
![image](https://github.com/lsmakethebest/LSPanSwiper/blob/master/1.gif)


