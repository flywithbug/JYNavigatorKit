//
//  NSString+urlExt.m
//  JYNavigator
//
//  Created by Flywithbug on 2019/9/24.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "NSString+urlExt.h"
//#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation NSString (urlExt)



- (NSString *)stringByAddingPercentEscapesUsingEncodingExt:(NSStringEncoding)enc{
    
    NSString * newString = (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            CFStringConvertNSStringEncodingToEncoding(enc));
    
    return newString;
    
}

- (NSString *)stringByReplacingPercentEscapesUsingEncodingExt:(NSStringEncoding)enc{
    
    NSString * newString = (__bridge_transfer NSString *)
    CFURLCreateStringByReplacingPercentEscapes(NULL, (__bridge CFStringRef)self, CFSTR(""));
    
    return newString;
    
}


- (NSString *)stringByAddingPercentEscapes {
    return [self stringByAddingPercentEscapesUsingEncodingExt:NSUTF8StringEncoding];
}
- (NSString *)stringByReplacingPercentEscapes {
    return [self stringByReplacingPercentEscapesUsingEncodingExt:NSUTF8StringEncoding];
}

@end
