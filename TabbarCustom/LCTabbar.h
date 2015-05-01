//
//  LCTabbar.h
//  LuoChang
//
//  Created by Rick on 15/4/29.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#import <UIKit/UIKit.h>
#import "LCTabBarButton.h"
#define kTabbarHeight 49

@protocol LCTabBarDelegate <NSObject>

@required
-(void) changeNav:(NSInteger)from to:(NSInteger)to;

@end

@interface LCTabbar : UIView
@property(nonatomic,weak) id<LCTabBarDelegate> delegate;
@end
