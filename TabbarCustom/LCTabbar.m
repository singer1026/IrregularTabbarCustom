//
//  LCTabbar.m
//  LuoChang
//
//  Created by Rick on 15/4/29.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import "LCTabbar.h"
#import "LCTabBarController.h"

@interface LCTabbar()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    LCTabBarButton *_selectedBarButton;
}
@end

@implementation LCTabbar
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addBarButtons];
    }
    return self;
}

-(void) addBarButtons{
    for (int i = 0 ; i<5 ; i++) {
        LCTabBarButton *btn = [[LCTabBarButton alloc] init];
        CGFloat btnW = self.frame.size.width/5;
        CGFloat btnX = i * btnW;
        CGFloat btnY = 0;
        
        CGFloat btnH = self.frame.size.height;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        NSString *imageName = [NSString stringWithFormat:@"TabBar%d",i+1];
        NSString *selImageName = [NSString stringWithFormat:@"TabBar%dSel",i+1];
        NSString *title;
        if (i==0) {
            title = @"首页";
        }else if(i==1){
            title = @"资讯";
        }else if(i==2){
            imageName = @"摄影机图标_点击前";
            selImageName =@"摄影机图标_点击后";
        }else if(i==3){
            title = @"数据";
        }else if(i==4){
            title = @"我";
        }
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
        btn.tag = i;
        if (i!=2) {
            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:RGB(29, 173, 248) forState:UIControlStateSelected];
            [btn setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
            [self addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        }
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self addSubview:btn];
        
        if(i == 0){
            [self btnClick:btn];
        }
    }
}


-(void) btnClick:(UIButton *)button{
    if (button.tag!=2) {
        [self.delegate changeNav:_selectedBarButton.tag to:button.tag];
        _selectedBarButton.selected = NO;
        button.selected = YES;
        _selectedBarButton = (LCTabBarButton *)button;
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"点击了 %ld",buttonIndex);
    if (buttonIndex != 2) {
        //        ImageViewController *imageVC = [[ImageViewController alloc]init];
        LCTabBarController *tabVC = (LCTabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        //        [tabVC.selectedViewController.childViewControllers.lastObject  presentViewController:imageVC animated:YES completion:^{}];
        
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if([UIImagePickerController isSourceTypeAvailable:type]){
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                type = UIImagePickerControllerSourceTypeCamera;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = NO;
            picker.delegate   = self;
            picker.sourceType = type;
            
            [tabVC.selectedViewController.childViewControllers.lastObject  presentViewController:picker animated:YES completion:^{
                
            }];
        }
        
        
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"image  %@",image);
    }];
    
}

@end
