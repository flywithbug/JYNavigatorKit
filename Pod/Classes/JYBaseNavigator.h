//
//  JYNavigator.h
//  JYViewController
//
//  Created by Flywithbug on 2019/9/20.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYURLAction.h"
#import "JVNavigatorViewControllerProtocol.h"


//当前控制器
UIViewController *AutoGetTopViewController(void);

UINavigationController* AutoGetCurrentNavigationController(UIViewController *sourceVC);

@interface JYBaseNavigator : NSObject
{
    UINavigationController *_mainNavigationController;
    NSString *_urlScheme;
    NSString *_urlHost;
//    NSArray *_fileNamesUrlMapping;
}

/**
 启动时需设置主导航控制器
 */
@property (nonatomic, strong,readonly) UINavigationController *mainNavigationController;
//flywithbug://flywithbug.com
@property (nonatomic, copy,  readonly) NSString *urlScheme;//可以使用的scheme flywithbug
@property (nonatomic, copy,  readonly) NSString *urlHost;//可以使用的host flywithbug.com
@property (nonatomic, copy, readonly) NSArray *filePathsUrlMapping;//urlmapping文件

@property (nonatomic, copy,  readonly) NSDictionary <NSString *,JYURLTarget *>*urlMappings;//host与JYURLTarget映射关系


@property (nonatomic, readonly) BOOL animating;

- (BOOL)inBlockMode;
- (BOOL)canOpenInBlockMode:(UIViewController *)pushed;

- (Class)matchClassWithURLAction:(JYURLAction *)urlAction;

/*
 * 注册路由信息 {"path":"className"}
 */
- (void)registURLMappingsFromDic:(NSDictionary <NSString *,NSString *>*)urlmappings;

/*
 * 从文件添加路由配置
 #warning  此方法暂时废弃 后期看需求增加
 文件样式：如示例文件 urlmapping

 路径+名称。 NSString *path =[[NSBundle mainBundle]pathForResource:@"urlmapping" ofType:nil];

 ####### 配置中心 #######
 test                :ViewController   #test
 test1               :Test1ViewController  #test1


 */

//- (void)registURLMappingsFromFilePaths:(NSArray *)filePaths;


//打开外链
- (void)openExternalURL:(NSURL *)url;

//回退到path
- (BOOL)pop2Path:(NSString *)path;
- (BOOL)isFromPath:(NSString *)path;
//回退到数组中任意path
- (BOOL)pop2AnyPath:(NSArray *)pathArray;


////回退到scheme
//- (BOOL)pop2Scheme:(NSString *)scheme __attribute((deprecated("已废弃 use -pop2Path: instead.")));
////回退到数组中任意scheme
//- (BOOL)pop2AnyScheme:(NSArray *)schemeArray __attribute((deprecated("已废弃 use -pop2AnyPath: instead.")));
//- (BOOL)isFromScheme:(NSString *)scheme  __attribute((deprecated("已废弃 use -isFromPath: instead.")));

//登陆态状态Block
//- (void)setLoginStatusBlock:(JYLoginStatusBlock)block;



//+ (UIViewController *)getTopViewController;
//+ (UINavigationController *)currentNavigationController:(UIViewController *)sourceVC;
@end

