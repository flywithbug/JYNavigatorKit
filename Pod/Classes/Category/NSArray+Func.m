//
//  NSArray+Func.m
//  JYViewController
//
//  Created by Flywithbug on 2019/9/23.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "NSArray+Func.h"

@implementation NSArray (Func)
- (id)JY_match:(JYValidationBlock)block{
    for (id object in self) {
        if (block(object)) {
            return object;
        }
    }
    return nil;
}


- (BOOL)JY_existObjectMatch:(JYValidationBlock)block {
    return [self JY_match:block] != nil;
}
- (id)JY_find:(JYValidationBlock)block{
    for (id obj in self) {
        if (block(obj)) {
            return obj;
        }
    }
    return nil;
}

@end
