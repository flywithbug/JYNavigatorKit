//
//  NSURL+parseExt.m
//  JYNavigator
//
//  Created by Flywithbug on 2019/9/18.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "NSURL+parseExt.h"

@implementation NSURL (parseExt)

- (NSDictionary *)parseQuery {
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if ([elements count] <= 1) {
            continue;
        }
        NSString *key = [[elements objectAtIndex:0] stringByRemovingPercentEncoding];
        CFStringRef originValue = CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)([elements objectAtIndex:1]),  CFSTR(""));
        NSString *oriValue = (__bridge NSString*)originValue;
        NSAssert(oriValue != nil, @"url is invalid");
        if (oriValue) {
            [dict setObject:oriValue forKey:key];
        }
        CFRelease(originValue);
    }
    return dict;
}

@end
