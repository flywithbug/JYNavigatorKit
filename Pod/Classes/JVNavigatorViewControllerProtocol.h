//
//  JVNavigatorViewControllerProtocol.h
//  JYViewController
//
//  Created by Flywithbug on 2019/9/23.
//  Copyright © 2019 flywithbug. All rights reserved.
//
#import "JYURLAction.h"



#ifndef JVNavigatorViewControllerProtocol_h
#define JVNavigatorViewControllerProtocol_h



@protocol JVNavigatorViewControllerProtocol <NSObject>

@optional

/**
 页面是否是单例（即在导航堆栈中只会保留一个页面，当跳转到该页面的时候会将其堆栈之上的页面都pop掉）
 默认是NO
 */
+ (BOOL)isSingleton;


/**
 询问在进入该页面之前是否需要先登录
 默认是NO
 */
+ (BOOL)needsLogin:(JYURLAction *)urlAction;


/**
 导航控制器将要显示页面前，会调用handleWithURLAction:方法
 */
- (BOOL)handleWithURLAction:(JYURLAction *)urlAction;


@end






#endif /* JVNavigatorViewControllerProtocol_h */
