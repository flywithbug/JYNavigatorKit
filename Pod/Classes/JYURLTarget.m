//
//  JYURLTarget.m
//  JYNavigator
//
//  Created by Flywithbug on 2019/9/19.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "JYURLTarget.h"

@interface JYURLTarget ()
@property (nonatomic, copy,readwrite) NSString *targetString;
@end

@implementation JYURLTarget

+ (JYURLTarget*)targetWithClassName:(NSString *)className withKey:(NSString *)key{
    return [[self alloc]initWithString:className withKey:key];
}

- (instancetype)initWithString:(NSString *)string withKey:(NSString *)key{
    self = [super init];
    if (self) {
        if (string.length == 0 || key.length == 0) {
            NSAssert(0, @"scheme or targetName is nil");
            return nil;
        }
        _key = key;
        _targetString = string;
    }
    return self;
}

- (Class)targetClass {
    if (_targetString.length<1) {
        return NULL;
    }
    return NSClassFromString(_targetString);
}


@end
