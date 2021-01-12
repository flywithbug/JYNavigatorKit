//
//  UIViewController+Navigator.m
//  JYViewController
//
//  Created by Flywithbug on 2019/9/24.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "UIViewController+Navigator.h"
#import "JYNavigator.h"
#import "NSString+urlExt.h"

@implementation UIViewController (Navigator)
- (NSString *)schemeURL{
    return [NSString stringWithFormat:@"%@://%@",[JYNavigator navigator].urlScheme,[JYNavigator navigator].urlHost];
}


//- (UIViewController *)openURLHost:(NSString *)urlHost{
//    NSString *scheme = [[JYNavigator navigator] urlScheme];
//    if (scheme.length<1 || urlHost.length<1) {
//        return nil;
//    }
//     return [[JYNavigator navigator] openURLString:[NSString stringWithFormat:@"%@://%@", scheme, urlHost] fromViewController:self];
//}

- (UIViewController *)openURLPath:(NSString *)path{
    return [[JYNavigator navigator]openPathString:path];
}

- (UIViewController *)openURL:(NSURL *)url {
    return [[JYNavigator navigator] openURL:url fromViewController:self];
}

- (UIViewController *)openURLString:(NSString *)urlString {
    return [[JYNavigator navigator] openURLString:urlString fromViewController:self];
}

- (UIViewController *)openHttpURLString:(NSString *)httpURLString{
     return [[JYNavigator navigator]openHttpURLString:httpURLString];
}

- (UIViewController *)openURLFormat:(NSString *)urlFormat, ...{
    if (urlFormat.length<1) {
        return nil;
    }
    va_list ap;
    va_start(ap, urlFormat);
    NSString *urlString = [[NSString alloc] initWithFormat:urlFormat arguments:ap];
    va_end(ap);
    return [[JYNavigator navigator] openURLString:urlString fromViewController:self];
}

- (UIViewController *)openURLAction:(JYURLAction *)urlAction {
    return [[JYNavigator navigator] openURLAction:urlAction fromViewController:self];
}


- (BOOL)pop2Path:(NSString *)path{
    return [[JYNavigator navigator]pop2Path:path];
}
- (BOOL)pop2AnyPath:(NSArray *)pathArray{
    return [[JYNavigator navigator]pop2AnyPath:pathArray];
}
- (BOOL)isFromPath:(NSString *)path{
    return [[JYNavigator navigator]isFromPath:path];
}

- (BOOL)handleWithURLAction:(JYURLAction *)urlAction{
    if (urlAction.pushCompleteBlock) {
        urlAction.pushCompleteBlock();
    }
    return YES;
}
+ (BOOL)isSingleton{return NO;}
+ (BOOL)needsLogin:(JYURLAction *)urlAction{return NO;}

@end
