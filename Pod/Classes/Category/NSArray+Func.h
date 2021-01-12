//
//  NSArray+Func.h
//  JYViewController
//
//  Created by Flywithbug on 2019/9/23.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
typedef  BOOL (^JYValidationBlock)(id obj);

@interface NSArray (Func)

- (id)JY_match:(JYValidationBlock)block;
- (BOOL)JY_existObjectMatch:(JYValidationBlock)block;
- (id)JY_find:(JYValidationBlock)block;
@end

NS_ASSUME_NONNULL_END
