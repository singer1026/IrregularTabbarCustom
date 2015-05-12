//
//  LCTabBarController.m
//  LuoChang
//
//  Created by Rick on 15/4/29.
//  Copyright (c) 2015年 Rick. All rights reserved.
//
#define  kContentFrame  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kTabbarHeight)
#define  kDockFrame CGRectMake(0, self.view.frame.size.height-kTabbarHeight, self.view.frame.size.width, kTabbarHeight)

#define kCameraViewWidth 49
#define kCameraViewHeight 61
#define kCameraBtnWidth kCameraViewWidth
#define kCameraBtnHeight 50

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "LCTabBarController.h"
#import "LCTabbar.h"
@interface LCTabBarController ()<UINavigationControllerDelegate,LCTabBarDelegate>

@end

@implementation LCTabBarController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        for (UINavigationController *navVC in self.viewControllers) {
            navVC.delegate = self;
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNavigationTheme];
    
    self.tabBar.hidden = YES;
    LCTabbar *lctabBar = [[LCTabbar alloc]initWithFrame:self.tabBar.bounds];
    lctabBar.delegate = self;
    //    [self.tabBar addSubview:tabBar];
    CGRect frame = lctabBar.frame;
    lctabBar.frame = CGRectMake(0, self.view.frame.size.height-kTabbarHeight, frame.size.width, kTabbarHeight);
    self.mytabbar = lctabBar;
    lctabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab-_白色透明背景渐变"]];
    [self.view addSubview:lctabBar];
    
    _cameraView =[[UIView alloc]init];
    _cameraView.center = CGPointMake(SCREEN_WIDTH*0.5, SCREEN_HEIGHT-(kCameraViewHeight*0.5));
    _cameraView.bounds = CGRectMake(0, 0, kCameraViewWidth, kCameraViewHeight);
    _cameraView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_摄影机图标背景"]];
    _cameraBtn = [[UIButton alloc]init];
    [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"摄影机图标_点击前"] forState:UIControlStateNormal];
    [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"摄影机图标_点击后"] forState:UIControlStateHighlighted];
    _cameraBtn.frame = CGRectMake(0, 5, kCameraBtnWidth, kCameraBtnHeight);
    _cameraBtn.tag = 2;
    [_cameraBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraView addSubview:_cameraBtn];
    
    [self.view addSubview:_cameraView];

    
}


//
///**
// *  设置导航栏以及信号栏主题样式
// */
//-(void) setNavigationTheme{
//    
//    //操作整个应用中的所有导航栏，只需要给它设置就可以了
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    navBar.tintColor = [UIColor whiteColor];
//    //设置导航栏标题颜色
//    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//
//}




-(void)cameraClick:(UIButton *)btn{
    self.selectedIndex = btn.tag;
}

-(void)changeNav:(NSInteger)from to:(NSInteger)to{
    self.selectedIndex = to;
}




#pragma mark navVC代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *root = navigationController.viewControllers.firstObject;
    if (viewController != root) {
        //更改导航控制器的高度
        navigationController.view.frame = self.view.bounds;
        //从HomeViewController移除
        [_mytabbar removeFromSuperview];
        [_cameraView removeFromSuperview];
        // 调整tabbar的Y值
        CGRect dockFrame = _mytabbar.frame;
        CGRect cameraViewFrame = _cameraView.frame;
        if ([root.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollview = (UIScrollView *)root.view;
            dockFrame.origin.y = scrollview.contentOffset.y + root.view.frame.size.height - kTabbarHeight;
            cameraViewFrame.origin.y = scrollview.contentOffset.y + root.view.frame.size.height -kTabbarHeight - (kCameraViewHeight - kCameraViewWidth);
        } else {
            // dockFrame.origin.y -= kDockHeight;
            cameraViewFrame.origin.y = root.view.frame.size.height -kCameraViewHeight;
            dockFrame.origin.y = root.view.frame.size.height - kTabbarHeight;
        }
        _mytabbar.frame = dockFrame;
        
        _cameraView.frame = cameraViewFrame;

        //添加dock到根控制器界面
        [root.view addSubview:_mytabbar];
        [root.view addSubview:_cameraView];
        
        
    }
}



-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *root = navigationController.viewControllers[0];
    if (viewController == root) {
        // 更改导航控制器view的frame
        navigationController.view.frame = kContentFrame;
        
        // 让Dock从root上移除
        [_mytabbar removeFromSuperview];
        [_cameraView removeFromSuperview];
        
        //_mytabbar添加dock到HomeViewController
        _mytabbar.frame = kDockFrame;
        [self.view addSubview:_mytabbar];
        
        
        _cameraView.center = CGPointMake(SCREEN_WIDTH*0.5, SCREEN_HEIGHT-(kCameraViewHeight*0.5));
        _cameraView.bounds = CGRectMake(0, 0, kCameraViewWidth, kCameraViewHeight);
        [self.view addSubview:_cameraView];
//        [[UIApplication sharedApplication].keyWindow addSubview:_cameraView];
    }
    
}
@end
