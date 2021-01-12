//
//  JYMainTabViewController.m
//  JYViewController
//
//  Created by Flywithbug on 2019/9/24.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "JYMainTabViewController.h"
#import "ViewController.h"
#import "Test2ViewController.h"
#import "Test1ViewController.h"

@interface JYMainTabViewController ()

@end

@implementation JYMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadTabControllers];
    
}

- (void)loadTabControllers {
    ViewController *vc = [ViewController new];
    vc.title = @"Tab0";
    Test1ViewController *vc1 = [Test1ViewController new];
    vc1.title = @"Tab1";
    Test2ViewController *vc2 = [Test2ViewController new];
    vc2.title = @"Tab2";
    
    [self setViewControllers:@[vc,vc1,vc2]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
