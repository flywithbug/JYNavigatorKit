//
//  UIViewController+Navigator.h
//  JYViewController
//
//  Created by Flywithbug on 2019/9/24.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYURLAction.h"


NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Navigator)




///// 直接打开字符串
///// @param urlHost     hostname?a=b
//- (UIViewController *)openURLHost:(NSString *)urlHost;

/// 直接打开字符串
/// @param urlPath     path?a=b
- (UIViewController *)openURLPath:(NSString *)path;
/// 打开URL
/// @param url  flywithbug://hostname?a=b
- (UIViewController *)openURL:(NSURL *)url;
- (UIViewController *)openURLString:(NSString *)urlString;

/// 打开网页地址
/// @param httpURLString http://www.flywithbug.com
- (UIViewController *)openHttpURLString:(NSString *)httpURLString;

/// Description
/// @param urlFormat Format 字符串
- (UIViewController *)openURLFormat:(NSString *)urlFormat, ...;

/// 打开JYURLAction对象
/// @param urlAction action实例
- (UIViewController *)openURLAction:(JYURLAction *)urlAction;

- (BOOL)pop2Path:(NSString *)path;
- (BOOL)pop2AnyPath:(NSArray *)pathArray;
- (BOOL)isFromPath:(NSString *)path;



//return YES:当前控制器可以被open. NO:不可以被Open
- (BOOL)handleWithURLAction:(JYURLAction *)urlAction;
+ (BOOL)isSingleton;

//是否需要登录
+ (BOOL)needsLogin:(JYURLAction *)urlAction;
@end

NS_ASSUME_NONNULL_END
