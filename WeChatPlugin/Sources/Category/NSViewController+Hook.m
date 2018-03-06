//
//  NSViewController+Hook.m
//  WeChatPlugin
//
//  Created by Loveletter on 26/02/2018.
//  Copyright © 2018 CodeTips. All rights reserved.
//

#import "NSViewController+Hook.h"
#import "WeChatPlugin.h"
#import "MMTimeLineMainViewController.h"
#import "MMTimeLineViewController.h"

@implementation NSObject (NSViewController)

+ (void)hookNSViewController
{
    if (!CBGetClass(SnsTimeLineRequest)) {
        return;
    }
    CBRegisterClass(MMContactsViewController, MMTimeLineMainViewController);
    
    tk_hookMethod(objc_getClass("LeftViewController"), @selector(setViewControllers:), [self class], @selector(cb_setViewControllers:));
    tk_hookMethod(objc_getClass("MMViewController"), @selector(viewDidLoad), [self class], @selector(cb_mmDidLoad));
    tk_hookMethod(objc_getClass("MMPreviewViewController"), @selector(viewDidLoad), [self class], @selector(cb_preViewDidLoad));
    tk_hookMethod(objc_getClass("MMPreviewPanel"), @selector(show), [self class], @selector(cb_preshow));
}


- (void)cb_setViewControllers:(NSArray *)vcs {
    
    MMTimeLineMainViewController *timeLineMainVC = [[objc_getClass("MMTimeLineMainViewController") alloc] initWithNibName:@"MMContactsViewController" bundle:[NSBundle mainBundle]];
    [timeLineMainVC setTitle:[[NSBundle mainBundle] localizedStringForKey:@"Tabbar.Chats" value:@"" table:0x0]];
    
    
    MMTimeLineViewController *timeLineVC = [[objc_getClass("MMTimeLineViewController") alloc] initWithNibName:@"MMTimeLineViewController" bundle:[NSBundle pluginBundle]];
    timeLineMainVC.detailViewController = (id)timeLineVC;
    
    MMTabbarItem *tabBarItem = [[objc_getClass("MMTabbarItem") alloc] initWithTitle:@"朋友圈" onStateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-Selected"] onStateAlternateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-Selected-HI"] offStateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine"] offStateAlternateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-HI"]];
    [timeLineMainVC setTabbarItem:tabBarItem];
    
    NSMutableArray *viewControllers = [vcs mutableCopy];
    [viewControllers addObject:timeLineMainVC];
    [self cb_setViewControllers:[viewControllers copy]];
    
}

-(void)cb_mmDidLoad{
    NSLog(@"\n----\n ❤️ %@ didLoad \n----\n",NSStringFromClass([self class]));
}
-(void)cb_preViewDidLoad{
    
    [self cb_preViewDidLoad];
}

-(void)cb_preshow{
    [self cb_preshow];
}

@end
