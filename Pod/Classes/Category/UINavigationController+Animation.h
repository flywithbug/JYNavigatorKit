//
//  UINavigationController+Animation.h
//  JYViewController
//
//  Created by Flywithbug on 2019/9/23.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Animation)
@property (nonatomic, assign) BOOL inAnimating;

- (void)pushViewController:(UIViewController *)viewController withAnimation:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
