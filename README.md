# LSPanSwiper
## 几行代码实现交互式push pop动画,可以随意自定义push，pop动画
![image](https://github.com/lsmakethebest/LSPanSwiper/blob/master/2.gif)
### 开启设置只需要在UINavigationController里写以下代码
```
-(void)viewDidLoad{
    [super viewDidLoad];
    [self openSwiper];
    //self.canInteractive=NO;//所有界面禁用交互式pop动画
}
```
### 默认所有界面都可以交互式pop，默认push,pop动画为系统样式，如果想修改默认动画，在UINavigationController里实现以下代理方法
```
-(LSTransitionAnimator *)swiperAnimatorForDefaultWithIsPush:(BOOL)isPush{
    if (isPush) {
        return [PushAnimator1 new];//此处PushAnimator1为自己定义的动画
    }else{
        return  [PopAnimator1 new];////此处PopAnimator1为自己定义的动画
    }
}
```

### 如果想禁用所有界面pop交互式动画，则在UINavigationController里
```
-(void)viewDidLoad{
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
- (UIViewController *)swiperBeginPushToNextController:(LSPanSwiper *)swiper{
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
### 如果想要扩散动画
```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushAnimator=[LSSpreadPushAnimator new];
    self.pushAnimator.canInteractive=NO;//此动画使用CABasicAnimation,在ios11上不支持交互式动画，原因未知
}

//圆形扩散动画
- (IBAction)push:(id)sender {
    self.pushAnimator.enabled=YES;//此处修改为YES因为下面有设置weiNO的地方
    self.pushAnimator.isCircel=YES;
    self.pushAnimator.fromRect=self.button1.frame;
    SecondViewController *controller = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
//矩形扩散动画
- (IBAction)push2:(id)sender {
    self.pushAnimator.enabled=YES;
    self.pushAnimator.isCircel=NO;
    self.pushAnimator.fromRect=self.button2.frame;
    SecondViewController *controller = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
//同一界面有多自定义动画，还想使用默认push动画，push时只需要设置自定义动画的enabled=NO,需要时在打开就好了
- (IBAction)push3:(id)sender {
    self.pushAnimator.enabled=NO;
    ThreeViewController *controller = [[ThreeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
```
### 使用了扩散push动画，pop如果用的是缩放pop动画，用圆缩放还是矩形缩放，系统会自动记录，如果用的是其他pop动画，则随意
### 注意点在iOS11上使用CABasicAnimation实现动画，则不支持交互式，具体原因未找到，所以动画尽量使用UIView animation



