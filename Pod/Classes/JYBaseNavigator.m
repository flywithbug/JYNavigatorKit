//
//  JYNavigator.m
//  JYViewController
//
//  Created by Flywithbug on 2019/9/20.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "JYBaseNavigator.h"
#import "UINavigationController+Animation.h"
#import "JYNavigatorDefinition.h"
#import "NSArray+Func.h"



//当前控制器
UIViewController *AutoGetTopViewController(void) {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topVC = keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
 
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        topVC = ((UINavigationController*)topVC).topViewController;
    }
    
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        topVC = ((UITabBarController*)topVC).selectedViewController;
    }
    
    return topVC;
}

UINavigationController* AutoGetCurrentNavigationController(UIViewController *sourceVC) {
    UINavigationController *navigationController = nil;
    if ([sourceVC isKindOfClass:[UINavigationController class]]) {
        navigationController = (id)sourceVC;
    } else {
        UIViewController *superViewController = sourceVC.parentViewController;
        while (superViewController) {
            if ([superViewController isKindOfClass:[UINavigationController class]]) {
                navigationController = (id)superViewController;
                break;
            } else {
                superViewController = superViewController.parentViewController;
            }
        }
    }
    
    return navigationController;
}



@interface JYBaseNavigator ()
@property (nonatomic, strong) NSTimer *checkBlockTimer;
@property (nonatomic, strong) NSMutableArray <JYURLAction *>*urlActionWaitingList;
@property (nonatomic, strong) NSMutableDictionary <NSString*,JYURLTarget *>*mutURLMapping;
@property (nonatomic, strong) NSMutableSet <NSString *>*fileNamesSet;
@property (nonatomic, copy,  readwrite) NSDictionary <NSString *,JYURLTarget *>*urlMappings;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation JYBaseNavigator
@synthesize mainNavigationController = _mainNavigationController;
@synthesize urlScheme = _urlScheme;
@synthesize urlHost = _urlHost;
@synthesize filePathsUrlMapping = _filePathsUrlMapping;

- (instancetype)init{
    self = [super init];
    if (self) {
        _urlActionWaitingList = [NSMutableArray array];
        _urlScheme = @"flywithbug";
        _urlHost = @"flywithbug.com";
        _fileNamesSet = [NSMutableSet set];
        _mutURLMapping = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc]init];
    }
    return self;
}

- (UINavigationController *)mainNavigationController{
    if (_mainNavigationController) {
        return _mainNavigationController;
    }
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        _mainNavigationController =   (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    }
    if (!_mainNavigationController) {
        _mainNavigationController = AutoGetCurrentNavigationController(AutoGetTopViewController());
    }
    return _mainNavigationController;
}


- (BOOL)animating {
    if (![self.mainNavigationController respondsToSelector:@selector(inAnimating)]) {
        return NO;
    }
    return self.mainNavigationController.inAnimating;
}

- (BOOL)inBlockMode{
    return [self.mainNavigationController presentedViewController]|| self.animating;
}

- (BOOL)canOpenInBlockMode:(UIViewController *)pushed{
    return ![self inBlockMode];
}

- (void)checkTimerBlockModeDismiss{
    if (_urlActionWaitingList.count < 1) {
        if (_checkBlockTimer) {
            [_checkBlockTimer invalidate];
        }
        _checkBlockTimer = nil;
        return;
    }
    if (![self inBlockMode]) {
        if (_checkBlockTimer) {
            [_checkBlockTimer invalidate];
        }
        _checkBlockTimer = nil;
        [self flush];
    }
}

- (void)flush{
    while (_urlActionWaitingList.count > 0) {
        if ([self inBlockMode]) {
            if (!_checkBlockTimer) {
                _checkBlockTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(checkTimerBlockModeDismiss) userInfo:nil repeats:YES];
            }
            return;
        }
        JYURLAction *action = _urlActionWaitingList.firstObject;
        [_urlActionWaitingList removeObject:action];
        [self handleOpenURLAction:action];
    }
}

- (JYURLTarget *)matchTargetWithURLAction:(JYURLAction *)action{
    if (action.url.host.length == 0) {
        return nil;
    }
    NSString *key = [NSString stringWithFormat:@"%@",action.url.relativePath];
    return [self.urlMappings objectForKey:[key lowercaseString]];
}

- (Class)matchClassWithURLAction:(JYURLAction *)urlAction{
    JYURLTarget *target = [self matchTargetWithURLAction:urlAction];
    if (target) {
        return target.targetClass;
    }
    return NULL;
}

- (UIViewController *)obtainControllerWithTarget:(JYURLTarget *)target{
    if (target.targetClass == NULL) {
        return nil;
    }
    BOOL isSingleton = target.isSingleton;
    Class class = target.targetClass;
    if ([class respondsToSelector:@selector(isSingleton)] && [class isSingleton]) {
        isSingleton = YES;
    }
    if (isSingleton) {
        UIViewController *controller = [[self.mainNavigationController viewControllers]JY_match:^BOOL(UIViewController *vc) {
            return [vc isKindOfClass:class];
        }];
        return controller?controller:[class new];
    }
    return [class new];
}

- (UIViewController *)obtainTargetControllerAndCheckURLAction:(JYURLAction *)urlAction open:(BOOL)open{
    if (!urlAction || !urlAction.url || !self.mainNavigationController) {
        return nil;
    }
    if (![self shouldOpenURLAction:urlAction]) {
        return nil;
    }
    if (urlAction.openExternal) {
        [self willOpenExternal:urlAction];
        [self openExternalURL:urlAction.url];
        return nil;
    }
    NSString *scheme = urlAction.url.scheme;
    //判断是否本应用scheme
    if ([self.urlScheme caseInsensitiveCompare:scheme] != NSOrderedSame) {
        [self willOpenExternal:urlAction];
        [self openExternalURL:urlAction.url];
        return nil;
    }
    JYURLTarget *target =[self matchTargetWithURLAction:urlAction];
    if (!target) {
        [self onMatchUnhandledURLAction:urlAction];
        return nil;
    }
    target.isSingleton = urlAction.isSingleton;
    urlAction.urlTarget = target;
    UIViewController *controller = [self obtainControllerWithTarget:target];
    if (!controller) {
        [self onMatchUnhandledURLAction:urlAction];
        return nil;
    }
    [self onMatchViewController:controller withURLAction:urlAction];
    
    if (![self canOpenInBlockMode:controller]) {
        // in block mode, url action will send to waiting list
        [_urlActionWaitingList addObject:urlAction];
        if (!_checkBlockTimer) {
            _checkBlockTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(checkTimerBlockModeDismiss) userInfo:nil repeats:YES];
        }
        return nil;
    }
    [self willOpenURLAction:urlAction];
    
    if ([self handleLoginAction:urlAction withController:controller]) {
        return nil;
    }
    return controller;
}

- (UIViewController *)handleOpenURLAction:(JYURLAction *)action{
    return [self handleOpenURLAction:action open:YES];
}

- (UIViewController *)handleOpenURLAction:(JYURLAction *)urlAction open:(BOOL)open{
    UIViewController *controller = [self obtainTargetControllerAndCheckURLAction:urlAction open:open];
    if(!controller) return nil;
    if (open) {
        [self openViewController:controller withURLAction:urlAction];
    }else{
        //#warning - TODO完善
        if ([[controller class]respondsToSelector:@selector(isSingleton)]) {
            if ([[controller class] isSingleton]) {
                return nil;
            }
        }
        controller.urlAction = urlAction;
        [self commonHandleURLAction:urlAction inViewController:controller];
    }
    return controller;
}

- (void)openViewController:(UIViewController *)controller withURLAction:(JYURLAction *)urlAction {
    BOOL isSingleton = NO;
    if (urlAction.isSingleton) {
        isSingleton = urlAction.isSingleton;
    }else{
        if ([[controller class]respondsToSelector:@selector(isSingleton)]) {
            isSingleton = [[controller class]isSingleton];
        }
    }
    if ([self commonHandleURLAction:urlAction inViewController:controller]) return;
    
    if (isSingleton) {
        [self pushSingletonViewController:controller withURLAction:urlAction];
    }else{
        [self pushViewController:controller withURLAction:urlAction];
    }
}

- (BOOL)commonHandleURLAction:(JYURLAction *)urlAction inViewController:(UIViewController *)controller{
    if ([controller respondsToSelector:@selector(handleWithURLAction:)]) {
        return ![(id<JVNavigatorViewControllerProtocol>)controller handleWithURLAction:urlAction];
    }
    return NO;
}

- (void)pushSingletonViewController:(UIViewController *)controller withURLAction:(JYURLAction *)urlAction{
    if (!controller) return;
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.mainNavigationController.viewControllers];
    if ([controllers JY_existObjectMatch:^BOOL(UIViewController * obj) {return (obj == controller);}]) {
        if (controller != controllers.lastObject) {
            while (controllers.count > 1) {
                [controllers removeLastObject];
                if (controller == controllers.lastObject) {
                    break;
                }
            }
            [self.mainNavigationController setViewControllers:controllers animated:urlAction.animation];
        }else{
            [controller viewWillAppear:NO];
            [controller viewDidAppear:NO];
        }
    }else{
        [self pushViewController:controller withURLAction:urlAction];
    }
}

- (void)pushViewController:(UIViewController *)controller withURLAction:(JYURLAction *)urlAction {
    if (urlAction.options == JYAnimationOptionsPresent) {
        UINavigationController *nav = [[self.mainNavigationController.class alloc]initWithRootViewController:controller];
        [self.mainNavigationController presentViewController:nav animated:urlAction.animation completion:^{
            if (urlAction.pushCompleteBlock) {
                urlAction.pushCompleteBlock();
            }
        }];
    }else{
      [self.mainNavigationController pushViewController:controller withAnimation:urlAction.animation];
    }
    
    //退出栈内对应Path的控制器
    if (urlAction.popPathsAfterPush.count) {
        [self popPathsAfterPush:urlAction currentVC:controller];
    }else if(urlAction.pop2PathAfterPush && urlAction.pop2PathAfterPush.length){
        [self pop2PathAfterPush:urlAction currentVC:controller];
    }else if (urlAction.popLeftAfterPush) {
        [self popLeftControllers];
    }else{
    }
}

- (void)popLeftControllers{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSMutableArray *controllers = [NSMutableArray array];
        if (weakSelf.mainNavigationController.viewControllers.count > 2) {
           [controllers addObject:weakSelf.mainNavigationController.viewControllers.firstObject];
           [controllers addObject:weakSelf.mainNavigationController.viewControllers.lastObject];
        }
        [weakSelf.mainNavigationController setViewControllers:controllers];
    });
}

- (void)pop2PathAfterPush:(JYURLAction *)action currentVC:(UIViewController *)vc{
	NSString *path = action.pop2PathAfterPush;
    if (path.length == 0) {
        return;
    }
    JYURLTarget *target = [_mutURLMapping objectForKey:[path lowercaseString]];
    Class class = target.targetClass;
    if (class == nil || ![self isFromPath:path]) {
		if (action.popLeftAfterPush) {
			[self popLeftControllers];
		}
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.35 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:weakSelf.mainNavigationController.viewControllers];
        for(NSInteger i = controllers.count - 2;i > 0;i --){
            UIViewController * obj = (UIViewController *)controllers[i];
            if ([obj isKindOfClass:class]) {
                break;
            }
			[obj viewWillDisappear:NO];
			[obj viewDidDisappear:NO];
			[controllers removeObject:obj];
        }
        [weakSelf.mainNavigationController setViewControllers:controllers];
    });
}

- (void)popPathsAfterPush:(JYURLAction *)action currentVC:(UIViewController *)vc{
     __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.35 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSMutableArray *controllers = [NSMutableArray arrayWithArray:weakSelf.mainNavigationController.viewControllers];
        for (NSString * path in action.popPathsAfterPush) {
            
            JYURLTarget *target = [weakSelf.mutURLMapping objectForKey:[path lowercaseString]];
            Class class = target.targetClass;
            if (class == nil) {
                continue;
            }
            for (UIViewController *obj in controllers.copy) {
                if ([obj isKindOfClass:class]) {
                    [obj viewWillDisappear:NO];
                    [obj viewDidDisappear:NO];
                    [controllers removeObject:obj];
                }
            }
        }
        //确保当前push对象存在
        [controllers removeObject:vc];
        [controllers addObject:vc];
        [weakSelf.mainNavigationController setViewControllers:controllers];
    });
}


- (NSDictionary <NSString*,JYURLTarget *>* )urlMappings{
    return self.mutURLMapping;
}


- (BOOL)pop2Path:(NSString *)path{
    if (path == nil) {
        return NO;
    }
    return [self pop2AnyPath:@[path]];
}

- (BOOL)isFromPath:(NSString *)path{
    JYURLTarget *target = [_mutURLMapping objectForKey:[path lowercaseString]];
    Class class = target.targetClass;
    if (class == nil) {
        return NO;
    }
    id tar = [self.mainNavigationController.viewControllers JY_find:^BOOL(id  _Nonnull obj) {
        return [obj isKindOfClass:class];
    }];
    return tar != nil;
}


- (NSArray <UIViewController *>*)removeControllerPath:(NSString *)path array:(NSArray <UIViewController *>*)arrlist{
    JYURLTarget *target = [_mutURLMapping objectForKey:[path lowercaseString]];
    Class class = target.targetClass;
    if (class == nil) {
        return arrlist;
    }
    NSMutableArray <UIViewController *>* tempArray = arrlist.mutableCopy;
    for (UIViewController * vc in arrlist) {
        if ([vc isKindOfClass:class]) {
            [tempArray removeObject:vc];
        }
    }
    return tempArray.copy;
}

- (UIViewController *)findController:(NSString *)path{
    JYURLTarget *target = [_mutURLMapping objectForKey:[path lowercaseString]];
    Class class = target.targetClass;
    if (class == nil) {
        return nil;
    }
    id tar = [self.mainNavigationController.viewControllers JY_find:^BOOL(id  _Nonnull obj) {
        return [obj isKindOfClass:class];
    }];
    return tar;
}

- (BOOL)pop2AnyPath:(NSArray *)pathArray{
    if (pathArray.count == 0 || !self.mainNavigationController) {
          return NO;
      }
      if ([self inBlockMode]) {
          return NO;
      }
      for(NSInteger i = 0;i < self.mainNavigationController.viewControllers.count;i ++){
          for (NSString *scheme in pathArray){
              JYURLTarget *target = [_mutURLMapping objectForKey:[scheme lowercaseString]];
              Class class = target.targetClass;
              if (class == nil)return NO;
              if ([self.mainNavigationController.viewControllers[i] isKindOfClass:class]) {
                  [self.mainNavigationController popToViewController:self.mainNavigationController.viewControllers[i] animated:YES];
                  return YES;
              }
          }
      }
    return NO;
}

//- (BOOL)pop2Scheme:(NSString *)scheme{
//    if (scheme == nil) {
//        return NO;
//    }
//    return [self pop2AnyScheme:@[scheme]];
//}
//
//- (BOOL)pop2AnyScheme:(NSArray *)schemeArray{
//    return [self pop2AnyPath:schemeArray];
//}
//
//- (BOOL)isFromScheme:(NSString *)scheme{
//    return [self isFromPath:scheme];
//}

#pragma mark - 子类可以实现此 life circle

//此action 能否被使用。 可以在此做filter
- (BOOL)shouldOpenURLAction:(JYURLAction *)urlAction {
    return YES;
}


//未能处理的action
- (void)onMatchUnhandledURLAction:(JYURLAction *)urlAction {
    
}

//将要打开外链，
- (void)willOpenExternal:(JYURLAction *)urlAction {
}

//将要打开match到的controller
- (void)onMatchViewController:(UIViewController *)controller withURLAction:(JYURLAction *)urlAction {
    //

}

//将要打开action
- (void)willOpenURLAction:(JYURLAction *)urlAction {
    
}

- (BOOL)handleLoginAction:(JYURLAction *)urlAction withController:(UIViewController *)controller {
    return [self handleLoginAction:urlAction];
}

//是否需要登录处理
- (BOOL)handleLoginAction:(JYURLAction *)urlAction{
    return NO;
}

#pragma mark-- public method
- (void)openExternalURL:(NSURL *)url{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:url];
#pragma clang diagnostic pop
    }
}


#pragma mark- 添加maping映射数据
- (void)registURLMappingsFromDic:(NSDictionary *)urlmappings{
    [self.lock lock];
    NSMutableDictionary <NSString*,JYURLTarget *>*tempDic = [NSMutableDictionary dictionary];
    NSAssert(urlmappings.count > 0, @"[url mapping error] urlmapping dictionary is empty!!!!");
    if (urlmappings.count > 0) {
        __weak typeof(self) weakSelf = self;
        [urlmappings enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull kPath, NSString *  _Nonnull vClassName, BOOL * _Nonnull stop) {
            kPath = [kPath lowercaseString];
            NSString *kPath1 = nil;
            if (![kPath hasPrefix:@"/"]) {
                kPath1 = [NSString stringWithFormat:@"/%@",kPath];
            }
#if defined(DEBUG)
            if ([tempDic objectForKey:kPath] || [weakSelf.mutURLMapping objectForKey:kPath]) {
                NSString *msg = [NSString stringWithFormat:@"[url mapping error] host (%@) duplicate!!!!", kPath];
                NSAssert(0, msg);
            }
#endif
            JYURLTarget *target  = [JYURLTarget targetWithClassName:vClassName withKey:kPath];
            if (target) {
                [tempDic setObject:target forKey:kPath];
            }
            if (kPath1) {
                JYURLTarget *target1  = [JYURLTarget targetWithClassName:vClassName withKey:kPath1];
                if (target1) {
                    [tempDic setObject:target1 forKey:kPath1];
                }
            }
        }];
    }
    [self.mutURLMapping addEntriesFromDictionary:tempDic];
    self.urlMappings = self.mutURLMapping.copy;
    [self.lock unlock];
}

- (NSArray *)filePathsUrlMapping{
    return self.fileNamesSet.allObjects;
}


@end
