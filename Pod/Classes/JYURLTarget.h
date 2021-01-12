//
//  JYURLTarget.h
//  JYNavigator
//
//  Created by Flywithbug on 2019/9/19.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYURLTarget : NSObject
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly) NSString *targetString;
@property (nonatomic, readonly)  Class targetClass;

@property (nonatomic, assign) BOOL isSingleton;

+ (JYURLTarget*)targetWithClassName:(NSString *)className withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
