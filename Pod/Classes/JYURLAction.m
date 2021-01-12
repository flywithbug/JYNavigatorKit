//
//  JYURLAction.m
//  JYNavigator
//
//  Created by Flywithbug on 2019/9/18.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "JYURLAction.h"
#import "NSURL+parseExt.h"
#import <objc/runtime.h>
#import "JYNavigator.h"
#import "NSString+urlExt.h"

@interface JYURLAction ()
@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, strong ,readwrite) NSDictionary* query;

@end

@implementation JYURLAction

- (NSString *)schemeURL{
    return [NSString stringWithFormat:@"%@://%@",[JYNavigator navigator].urlScheme,[JYNavigator navigator].urlHost];
}

+ (instancetype)actionWithURL:(NSURL *)url{
    return [[self alloc]initWithURL:url];
}

+ (instancetype)actionWithPath:(NSString *)host{
    return [[self alloc]initWithPath:host];
}
+ (instancetype)actionWithHttpURLString:(NSString *)urlString{
    return [[self alloc]initWithHttpURLString:urlString];
}
+ (instancetype)actionWithURLString:(NSString *)urlString{
    return [[self alloc]initWithURLString:urlString];
}

+ (instancetype)initBridgeAction{
    return [[self alloc]initBridgeAction];
}

+ (instancetype)bridgeAction{
    return [[self alloc]initBridgeAction];
}

+ (instancetype)bridgeUrlString:(NSString *)urlString{
    return [[self alloc]initBridgeUrlString:urlString];
}

- (instancetype)initBridgeUrlString:(NSString *)urlString{
    if (urlString && urlString.length) {
       NSString *tempString = [NSString stringWithFormat:@"%@/bridge?url=%@",[self schemeURL],[urlString stringByAddingPercentEscapes]];
        return [[JYURLAction alloc]initWithURLString:tempString];
    }
    return nil;
}

- (instancetype)initWithPath:(NSString *)path{
    if (path && path.length> 0) {
        if (![path hasPrefix:@"/"]) {
            path = [@"/" stringByAppendingString:path];
        }
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[self schemeURL],path];
        return [[JYURLAction alloc]initWithURLString:urlString];
    }
    return nil;
}
- (instancetype)initWithHttpURLString:(NSString *)url{
    NSString *urlString = [NSString stringWithFormat:@"%@/web?url=%@",[self schemeURL],[url stringByAddingPercentEscapes]];
    return [[JYURLAction alloc]initWithURLString:urlString];
}

- (instancetype)initBridgeAction{
    NSString *urlString = [NSString stringWithFormat:@"%@/bridge",[self schemeURL]];
    return [[JYURLAction alloc]initWithURLString:urlString];
}
- (instancetype)initWithURLString:(NSString *)url{
    return [[JYURLAction alloc]initWithURL:[NSURL URLWithString:url]];
}

- (instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        _animation = YES;
        _url = url;
        if (url.relativePath == nil) {
            NSAssert(0, @"need path like :'home'");
        }
        NSDictionary *dic = [url parseQuery];
        _params = [NSMutableDictionary dictionary];
        for (NSString *key in [dic allKeys]) {
            id value = [dic objectForKey:key];
            [_params setObject:value forKey:[key lowercaseString]];
            [_params setObject:value forKey:key];
        }

    }
    return self;
}


- (void)setInteger:(NSInteger)intValue forKey:(nonnull NSString *)aKey{
    [_params setObject:[NSNumber numberWithInteger:intValue] forKey:[aKey lowercaseString]];
    [_params setObject:[NSNumber numberWithInteger:intValue] forKey:aKey];
}

- (void)setDouble:(double)doubleValue  forKey:(nonnull NSString *)aKey{
    [_params setObject:[NSNumber numberWithDouble:doubleValue] forKey:[aKey lowercaseString]];
    [_params setObject:[NSNumber numberWithDouble:doubleValue] forKey:aKey];
}

- (void)setString:(NSString *)string forKey:(nonnull NSString *)aKey{
    if (string.length > 0) {
        [_params setObject:string forKey:[aKey lowercaseString]];
        [_params setObject:string forKey:aKey];
    }
}

- (void)setBool:(BOOL)value  forKey:(nonnull NSString *)aKey{
     [_params setObject:@(value) forKey:[aKey lowercaseString]];
     [_params setObject:@(value) forKey:aKey];
}

- (void)setAnyObject:(id )object forKey:(nonnull NSString*)aKey{
    if (object) {
        [_params setObject:object forKey:[aKey lowercaseString]];
        [_params setObject:object forKey:aKey];
    }
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary{
    if (!otherDictionary) {
        return;
    }
    for (NSString *key in otherDictionary) {
        [_params setObject:otherDictionary[key] forKey:[key lowercaseString]];
        [_params setObject:otherDictionary[key] forKey:key];
    }
}

- (NSDictionary *)queryDictionary {
    return _params;
}


- (void)addParamsFromURLAction:(JYURLAction *)action{
    NSMutableDictionary *dic = [action queryDictionary].mutableCopy;
    [self setString:action.url.absoluteString forKey:@"__pre_url__"];
    [dic removeObjectForKey:@"url"];
    [self addEntriesFromDictionary:dic];
}


- (NSInteger)integerForKey:(NSString *)key {
    NSString *urlStr = [_params objectForKey:[key lowercaseString]];
    if(urlStr) {
        if ([urlStr isKindOfClass:[NSString class]]) {
            return [urlStr integerValue];
        } else if ([urlStr isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)urlStr integerValue];
        }
    }
    return 0;
}

- (double)doubleForKey:(NSString *)key {
    NSString *urlStr = [_params objectForKey:[key lowercaseString]];
    if(urlStr) {
        if ([urlStr isKindOfClass:[NSString class]]) {
            return [urlStr doubleValue];
        } else if ([urlStr isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)urlStr doubleValue];
        }
    }
    return .0;
}

- (NSString *)stringForKey:(NSString *)key {
    NSString *urlStr = [_params objectForKey:[key lowercaseString]];
    if(urlStr) {
        if ([urlStr isKindOfClass:[NSString class]]) {
            return urlStr;
        }
    }
    return nil;
}
- (BOOL)BoolForKey:(NSString *)key{
    NSNumber *number = [_params objectForKey:[key lowercaseString]];
    if (number) {
        return number.boolValue;
    }
    return NO;
}
- (id)anyObjectForKey:(NSString *)key{
    return [_params objectForKey:[key lowercaseString]];
}


- (void)removeObjectForKey:(NSString *)key{
    [_params removeObjectForKey:[key lowercaseString]];
}
@end


@implementation UIViewController (urlAction)

- (void)setUrlAction:(JYURLAction *)urlAction {
    objc_setAssociatedObject(self, @"UIViewControllerJYURLAction", urlAction, OBJC_ASSOCIATION_RETAIN);
}

- (JYURLAction *)urlAction {
    return objc_getAssociatedObject(self, @"UIViewControllerJYURLAction");
}

@end

