//
//  JYURLAction.h
//  JYNavigator
//
//  Created by Flywithbug on 2019/9/18.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYURLTarget.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, JYAnimationOptions) {
    JYAnimationOptionsPush = 1 << 0, //调用 pushViewController:animated:
    //脱离JYNavigator导航体系，需要dismiss该页面之后之后才能继续使用JYNavigator导航
    JYAnimationOptionsPresent  = 1 << 1, //调用 presentViewController:animated:completion:
};


typedef void(^CallBackBlock)(id callBack);


@interface JYURLAction : NSObject

//初始化方法禁用
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

//导航地址
@property (nonatomic, strong, readonly) NSURL *url;

//@property (nonatomic, strong ,readonly) NSDictionary* query;

@property (nonatomic, strong) JYURLTarget *urlTarget;
//是否有动画
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, assign) JYAnimationOptions options;

//#warning TODO
//如果导航控制器栈中已存在，则使用栈中的对象
@property (nonatomic, assign) BOOL isSingleton;


//pop栈内paths中的控制器 优先级最高
@property (nonatomic, copy) NSArray <NSString *> *popPathsAfterPush;
//如果pop2Path未寻到对应控制器，执行popLeftAfterPush逻辑
//push到新页面之后，把栈内控制器pop到需要的页面 优先级高于 popLeftAfterPush
@property (nonatomic, copy) NSString * pop2PathAfterPush;
//push之后Pop之前的控制器
@property (nonatomic, assign) BOOL popLeftAfterPush;


@property (copy, nonatomic) void (^pushCompleteBlock)(void);
@property (nonatomic, copy) CallBackBlock callBlock;
/**
 是否外链，默认为 NO
 */
@property (nonatomic, assign) BOOL openExternal;

+ (instancetype)actionWithPath:(NSString *)path;
+ (instancetype)actionWithURL:(NSURL *)url;
+ (instancetype)actionWithURLString:(NSString *)urlString;
//初始化网页跳转
+ (instancetype)actionWithHttpURLString:(NSString *)urlString;
//桥接Action初始化
+ (instancetype)initBridgeAction;
+ (instancetype)bridgeAction;
+ (instancetype)bridgeUrlString:(NSString *)urlString;

- (instancetype)initWithPath:(NSString *)path;
//flywithbug://flywithbug.com/path
- (instancetype)initWithURL:(NSURL *)url;
//flywithbug://flywithbug.com/path
- (instancetype)initWithURLString:(NSString *)url;
- (instancetype)initWithHttpURLString:(NSString *)url;
//桥接action
- (instancetype)initBridgeAction;
//path:bridge?url=urlString
- (instancetype)initBridgeUrlString:(NSString *)urlString;

- (void)setInteger:(NSInteger)intValue forKey:(nonnull NSString *)aKey;
- (void)setDouble:(double)doubleValue  forKey:(nonnull NSString *)aKey;
- (void)setString:(NSString *)string forKey:(nonnull NSString *)aKey;
- (void)setBool:(BOOL)value  forKey:(nonnull NSString *)aKey;
- (void)setAnyObject:(id)object forKey:(nonnull NSString*)aKey;

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;

- (void)addParamsFromURLAction:(JYURLAction *)action;

- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)BoolForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (id)anyObjectForKey:(NSString *)key;

- (NSDictionary *)queryDictionary;

- (void)removeObjectForKey:(NSString *)key;

@end

@interface UIViewController (urlAction)
@property (nonatomic, strong) JYURLAction *urlAction;
@end

NS_ASSUME_NONNULL_END
