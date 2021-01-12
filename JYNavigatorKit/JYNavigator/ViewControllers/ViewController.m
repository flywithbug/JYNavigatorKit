//
//  ViewController.m
//  JYViewController
//
//  Created by Flywithbug on 2019/9/19.
//  Copyright © 2019 flywithbug. All rights reserved.
//

#import "ViewController.h"

#import "JYNavigator.h"


#import "User.h"

#import "ViewController.h"
#import <Lottie/Lottie.h>

@interface ViewController ()
@property(nonatomic, strong)LOTAnimationView *animationView0;
@property(nonatomic, strong) LOTAnimationView *exploreCoverAV;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation ViewController

- (BOOL)handleWithURLAction:(JYURLAction *)urlAction{
    NSLog(@"query:%@",[urlAction queryDictionary]);
    return [super handleWithURLAction:urlAction];
}

+ (BOOL)isSingleton{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"00";
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
    
    [self.view addSubview:self.animationView0];
    [self.view addSubview:self.exploreCoverAV];
    
}
- (void)testBtn1Action:(id)sender{
//    JYURLAction *action = [[JYURLAction alloc]initWithURLString:@"flywithbug://test1?a=b&c=d"];
//    [self openURLAction:action];
//    NSArray *arr =@[@"a",@"b"];
//    NSLog(@"%@",arr[2]);
    if (!self.semaphore) {
        return;
    }
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);


//    if (!self.animationView0.isAnimationPlaying) {
//        [self.animationView0 play];
//    }
//    if (!self.exploreCoverAV.isAnimationPlaying) {
//        [self.exploreCoverAV play];
//    }
//    [self openURLString:@"flywithbug://test1?a=b&c=d"];
    
}

- (void)testBtn2Action:(id)sender{
    JYURLAction *action = [[JYURLAction alloc]initWithURLString:@"flywithbug://test3"];
    [action setInteger:989899 forKey:@"int"];
    [action setString:@"sbc" forKey:@"string"];
    User *u =[User new];
    u.name = @"jack";
    [action setAnyObject:u forKey:@"user"];
    [self openURLAction:action];
}


-(LOTAnimationView*)animationView0{
    if(!_animationView0){
        _animationView0 = [LOTAnimationView animationNamed:@"bike" inBundle:[NSBundle bundleForClass:self.class]];
        _animationView0.frame = CGRectMake(50, 200, 187.6, 200);
        [_animationView0 setLoopAnimation:YES];
        _animationView0.backgroundColor = [UIColor redColor];
    }
    return _animationView0;
}

- (LOTAnimationView *)exploreCoverAV {
    if (_exploreCoverAV == nil) {
        _exploreCoverAV = [LOTAnimationView animationNamed:@"main_bg" inBundle:[NSBundle bundleForClass:self.class]];
        [_exploreCoverAV setLoopAnimation:true];
        [_exploreCoverAV setFrame:CGRectMake(50, 400, self.view.frame.size.width, 200)];
        [_exploreCoverAV setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _exploreCoverAV;
}



@end
