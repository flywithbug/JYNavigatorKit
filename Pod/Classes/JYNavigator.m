//
//  JYNavigator.m
//  JYViewController
//
//  Created by Flywithbug on 2019/9/24.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "JYNavigator.h"
#import "NSString+urlExt.h"


static JYNavigator *gNavigator = nil;


@interface JYBaseNavigator (Private)
- (UIViewController *)handleOpenURLAction:(JYURLAction *)urlAction;
- (UIViewController *)handleOpenURLAction:(JYURLAction *)urlAction open:(BOOL)open;
- (UIViewController *)openHttpURLAction:(JYURLAction *)urlAction;
@end

@interface JYNavigator ()
@property (nonatomic, strong) NSMutableSet <NSString *>*fileNamesSet;


@end

@implementation JYNavigator
+ (void)initialize{
    gNavigator = [[JYNavigator alloc]init];
}

+ (instancetype)navigator{
    return gNavigator;
}

- (NSString *)schemeURL{
    return [NSString stringWithFormat:@"%@://%@",self.urlScheme,self.urlHost];
}
- (void)setMainNavigationController:(UINavigationController *)mainNavigationContorller{
    _mainNavigationController = mainNavigationContorller;
}

- (void)setHandleableURLScheme:(NSString *)scheme{
    _urlScheme = scheme;
}
- (void)setHandleableURLHost:(NSString *)host{
    _urlHost = host;
}


- (UIViewController *)openURL:(NSURL *)url fromViewController:(UIViewController *)controller{
    if (url == nil) {
        return nil;
    }
    return [self openURLAction:[JYURLAction actionWithURL:url] fromViewController:controller];
}
- (UIViewController *)openURLString:(NSString *)urlString fromViewController:(UIViewController *)controller{
    if (urlString.length == 0) {
        return nil;
    }
    return [self openURLAction:[[JYURLAction alloc]initWithURLString:urlString] fromViewController:controller];
}

- (UIViewController *)openPathString:(NSString *)pathString{
    if (pathString.length == 0) {
        return nil;
    }
    return  [self openURLAction:[[JYURLAction alloc]initWithPath:pathString]];
}

- (UIViewController *)openBridgeString:(NSString *)string{
     if (string.length == 0) {
           return nil;
       }
       NSString *actionURL = [NSString stringWithFormat:@"%@/bridge?url=%@", [self schemeURL], [string stringByAddingPercentEscapes]];
       return [self openURLAction:[[JYURLAction alloc]initWithURLString:actionURL]];
}

- (UIViewController *)openHttpURLString:(NSString *)httpURLString{
    if (httpURLString.length == 0) {
        return nil;
    }
    NSString *actionURL = [NSString stringWithFormat:@"%@/web?url=%@", [self schemeURL], [httpURLString stringByAddingPercentEscapes]];
    return [self openURLAction:[[JYURLAction alloc]initWithURLString:actionURL]];
}

- (UIViewController *)openURLAction:(JYURLAction *)urlAction{
    return [self openURLAction:urlAction fromViewController:nil];
}

- (UIViewController *)openURLAction:(JYURLAction *)urlAction fromViewController:(UIViewController *)controller{
    if (![urlAction isKindOfClass:[JYURLAction class]]) {
        return nil;
    }
    return [self handleOpenURLAction:urlAction];
}




//此action 能否被使用。 可以在此做filter
- (BOOL)shouldOpenURLAction:(JYURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:shouldOpenURLAction:)]) {
        return [self.delegate navigator:self shouldOpenURLAction:urlAction];
    }
    return YES;
}



//未能处理的action
- (void)onMatchUnhandledURLAction:(JYURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:onMatchUnhandledURLAction:)]) {
        [self.delegate navigator:self onMatchUnhandledURLAction:urlAction];
    }
}

//将要打开外链，
- (void)willOpenExternal:(JYURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:willOpenExternal:)]) {
        [self.delegate navigator:self willOpenExternal:urlAction];
    }
}

//将要打开match到的controller
- (void)onMatchViewController:(UIViewController *)controller withURLAction:(JYURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:onMatchViewController:withURLAction:)]) {
        [self.delegate navigator:self onMatchViewController:controller withURLAction:urlAction];
    }
}

//将要打开action
- (void)willOpenURLAction:(JYURLAction *)urlAction {
    if ([self.delegate respondsToSelector:@selector(navigator:willOpenURLAction:)]) {
        [self.delegate navigator:self willOpenURLAction:urlAction];
    }
}

- (BOOL)handleLoginAction:(JYURLAction *)urlAction withController:(UIViewController *)controller {
    if ([self.delegate respondsToSelector:@selector(navigator:handleLoginAction:withController:)]) {
        return [self.delegate navigator:self handleLoginAction:urlAction withController:controller];
    }
    return [self handleLoginAction:urlAction];
}
//是否需要登录处理
- (BOOL)handleLoginAction:(JYURLAction *)urlAction{
    return NO;
}




@end
