//
//  JYNavigatorDefinition.h
//  JYNavigator
//
//  Created by Flywithbug on 2019/9/18.
//  Copyright © 2019 flywithbug. All rights reserved.
//




//JYIntentOptions 枚举 来决定用什么方式来打开控制器
typedef NS_OPTIONS(NSUInteger, JYNavigatorActionOptions) {
    JYNavigatorActionPush        = 1 << 0,   //调用 pushViewController:animated:
    JYNavigatorActionPop         = 1 << 1,   //调用 popToViewController:animated: 可以返回到任何指定的控制器。
    
    JYNavigatorActionPushClearTop      = 1 << 3,   //if options & JYIntentOptionsPush, push前移除掉前面所有的控制器
    JYNavigatorActionPushSingleTop     = 1 << 4,   //if options & JYIntentOptionsPush, push前移除掉同样类型的控制器
    
};


