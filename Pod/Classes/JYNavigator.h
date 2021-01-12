//
//  JYNavigator.h
//  JYViewController
//
//  Created by Flywithbug on 2019/9/24.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "JYBaseNavigator.h"
#import "UIViewController+Navigator.h"

@class JYNavigator;

@protocol JYNavigatorDelegate <NSObject>

@optional
/**
 询问是否应该打开urlAction
 @param urlAction 待打开的urlAction
 */
- (BOOL)navigator:(JYNavigator *)navigator shouldOpenURLAction:(JYURLAction *)urlAction;

/**
 将要打开urlAction
 @param urlAction 待打开的urlAction
 */
- (void)navigator:(JYNavigator *)navigator willOpenURLAction:(JYURLAction *)urlAction;

/**
 urlAction将要使用外部程序打开
 @param urlAction 将要外部打开的urlAction
 */
- (void)navigator:(JYNavigator *)navigator willOpenExternal:(JYURLAction *)urlAction;

/**
 遇到了无法处理的urlAction
 @param urlAction 无法处理的urlAction
 */
- (void)navigator:(JYNavigator *)navigator onMatchUnhandledURLAction:(JYURLAction *)urlAction;

/**
 找到了映射的Class
 */
- (void)navigator:(JYNavigator *)navigator onMatchViewController:(UIViewController *)controller withURLAction:(JYURLAction *)urlAction;

/**
 未登录时处理登录需求
 */
- (BOOL)navigator:(JYNavigator *)navigator handleLoginAction:(JYURLAction *)urlAction withController:(UIViewController *)controller;

@end


@interface JYNavigator : JYBaseNavigator

+ (instancetype)navigator;

@property (nonatomic, weak) id<JYNavigatorDelegate> delegate;
/**
 设置程序的主导航控制器
 所有的页面跳转都会在mainNavigationContorller中进行
 */
- (void)setMainNavigationController:(UINavigationController *)mainNavigationContorller;

/**
 设置可以处理的URL Scheme
 默认是：@"flywithbug"
 */
- (void)setHandleableURLScheme:(NSString *)scheme;
/**
设置可以处理的URL Scheme
默认是：@"flywithbug.com"
*/
- (void)setHandleableURLHost:(NSString *)host;

/**
 url :[NSURL URLWithString:@"flywithbug://setting?name=abc"]
 */
- (UIViewController *)openURL:(NSURL *)url fromViewController:(UIViewController *)controller;
- (UIViewController *)openURLString:(NSString *)urlString fromViewController:(UIViewController *)controller;
- (UIViewController *)openURLAction:(JYURLAction *)urlAction fromViewController:(UIViewController *)controller;

- (UIViewController *)openURLAction:(JYURLAction *)urlAction;
- (UIViewController *)openHttpURLString:(NSString *)httpURLString;
- (UIViewController *)openPathString:(NSString *)pathString;


//统一桥接处理
- (UIViewController *)openBridgeString:(NSString *)string;

@end
