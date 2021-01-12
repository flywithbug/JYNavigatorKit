//
//  NSString+urlExt.h
//  JYNavigator
//
//  Created by Flywithbug on 2019/9/24.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (urlExt)

- (NSString *)stringByAddingPercentEscapesUsingEncodingExt:(NSStringEncoding)enc;
- (NSString *)stringByReplacingPercentEscapesUsingEncodingExt:(NSStringEncoding)enc;

/**
 url escape
 */
- (NSString *)stringByAddingPercentEscapes;
/**
 url unescape
 */
- (NSString *)stringByReplacingPercentEscapes;
@end

NS_ASSUME_NONNULL_END
