//
//  Test3ViewController.m
//  JYViewController
//
//  Created by Flywithbug on 2019/9/24.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "Test3ViewController.h"
#import "JYNavigator.h"
#import "User.h"

@interface Test3ViewController ()

@end

@implementation Test3ViewController

- (BOOL)handleWithURLAction:(JYURLAction *)urlAction{
    NSLog(@"test3--:%@",[urlAction queryDictionary]);
    User *use = [urlAction anyObjectForKey:@"user"];
    NSLog(@"user:%@",use);
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     self.navigationItem.title = @"03";
    // Do any additional setup after loading the view.
    UIButton *testBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testBtn1 setTitle:@"testBtn1" forState:UIControlStateNormal];
    [testBtn1 addTarget:self action:@selector(testBtn1Action:) forControlEvents:UIControlEventTouchUpInside];
    testBtn1.frame = CGRectMake(30, 100, 130, 44);
    [self.view addSubview:testBtn1];
    
    UIButton *testBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testBtn2 setTitle:@"testBtn2" forState:UIControlStateNormal];
    [testBtn2 addTarget:self action:@selector(testBtn2Action:) forControlEvents:UIControlEventTouchUpInside];
    testBtn2.frame = CGRectMake(30, 100 + 60 *1, 130, 44);
    [self.view addSubview:testBtn2];
    
}
- (void)testBtn1Action:(id)sender{
    JYURLAction *action = [[JYURLAction alloc]initWithURLString:@"flywithbug://test?a=b&c=d"];
    [self openURLAction:action];
    
}

- (void)testBtn2Action:(id)sender{
    [self pop2Scheme:@"test"];
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
