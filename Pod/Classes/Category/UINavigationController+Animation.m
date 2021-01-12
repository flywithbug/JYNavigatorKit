//
//  UINavigationController+Animation.m
//  JYViewController
//
//  Created by Flywithbug on 2019/9/23.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "UINavigationController+Animation.h"
#import <objc/runtime.h>
#import "JYURLAction.h"

@implementation UINavigationController (Animation)

+ (void)load{
    [self swizzleInstanceMethod:@selector(pushViewController:animated:) with:@selector(animation_pushViewController:animated:)];
}


- (void)animation_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (!animated && !viewController.urlAction.animation) {
        // 无动画
        [self animation_pushViewController:viewController animated:animated];
        self.inAnimating = NO;
        return;
    }
    self.inAnimating = YES;
    __weak typeof(self) weakSelf = self;
    [self animation_pushViewController:viewController animated:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        weakSelf.inAnimating = NO;
    });
}

- (void)pushViewController:(UIViewController *)viewController withAnimation:(BOOL)animated {
    [self pushViewController:viewController animated:animated];
    if (!animated) {
        // 无动画
        self.inAnimating = NO;
    }
}


- (void)setInAnimating:(BOOL)inAnimating{
     objc_setAssociatedObject(self, @selector(inAnimating), @(inAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)inAnimating{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}



@end
