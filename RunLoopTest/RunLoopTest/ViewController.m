//
//  ViewController.m
//  RunLoopTest
//
//  Created by anfa on 2020/6/9.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self basicUse];
    
//    [self timer1];
    
    [NSThread detachNewThreadWithBlock:^{
        [self timer2];
    }];
}

-(void)basicUse{
    [NSThread detachNewThreadWithBlock:^{
        //Foundation
        [NSRunLoop currentRunLoop];//获取当前线程的RunLoop对象
        [NSRunLoop mainRunLoop];//获取主线程RunLoop对象
        
        //Core Foundation
        CFRunLoopGetCurrent();//获取当前线程的RunLoop对象
        CFRunLoopGetMain();//获取主线程RunLoop对象
        
        NSLog(@"主线程----%@",[NSRunLoop mainRunLoop]);
        
        /*
         RunLoop创建时会选择一种运行模式，当调用run方法开启时，如果source和timer为空则认为运行模式为空，
         RunLoop就会退出。
         */
        NSRunLoop *newThreadRunLoop = [NSRunLoop currentRunLoop];
        NSLog(@"当前子线程----%@",newThreadRunLoop);
        [newThreadRunLoop run];
        
    }];
    
}

#pragma mark RunLoop运行模式和NSTimer
-(void)timer1{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    //添加到runloop中
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    //当UITextView滚动的时候，主运行循环会切换运行模式(默认->界面追踪运行模式)
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    /*被标记为commonModes的运行模式：UITrackingRunLoopMode | kCFRunLoopDefaultMode
     common modes = <CFBasicHash 0x6000034fc000 [0x7fff8062ce40]>{type = mutable set, count = 2,
     entries =>
         0 : <CFString 0x7fff868fd350 [0x7fff8062ce40]>{contents = "UITrackingRunLoopMode"}
         2 : <CFString 0x7fff80640110 [0x7fff8062ce40]>{contents = "kCFRunLoopDefaultMode"}
     }
     */
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void)timer2{
    NSLog(@"timer2+++++++++%@",[NSThread currentThread]);
    
    //监听事件必须在source或者Timer事件之前
    [self observeAction];
    
    //该方法内部会自动将创建的定时器对象添加到当前的RunLoop，并指定运行模式为默认
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    //手动创建子线程对应的runloop,否则不会执行
    [[NSRunLoop currentRunLoop] run];
    
}


-(void)run{
    NSLog(@"run--------%@",[NSRunLoop currentRunLoop].currentMode);
}

#pragma mark RunLoopObserve
-(void)observeAction{
    /*
     1、CFRunLoopObserverRef是观察者，能够监听RunLoop的状态改变
     2、可以监听的时间点有以下几个：
     typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
         kCFRunLoopEntry = (1UL << 0),            //即将进入Loop
         kCFRunLoopBeforeTimers = (1UL << 1),     //即将处理 Timer
         kCFRunLoopBeforeSources = (1UL << 2),    //即将处理 Source
         kCFRunLoopBeforeWaiting = (1UL << 5),    //即将进入休眠
         kCFRunLoopAfterWaiting = (1UL << 6),     //刚从休眠中唤醒
         kCFRunLoopExit = (1UL << 7),             //即将退出Loop
         kCFRunLoopAllActivities = 0x0FFFFFFFU
     };
     */
    /*
     参数说明
     参数一：分配存储控件  默认
     参数二：要监听的状态
     参数三：是否要持续监听
     参数四：0
     参数五：block回调 当RunLoop状态变化时会调用
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"runloop启动");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"runloop即将处理timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"runloop即将处理source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"runloop即将进入休眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"runloop被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"runloop退出");
                break;
            default:
                break;
        }
    });
    
    //监听RunLoop的状态
    /*
     参数说明
     参数一：RunLoop对象
     参数二：监听者
     参数三：RunLoop在那种运行模式下的状态
            kCFRunLoopDefaultMode = NSDefaultRunLoopMode
            kCFRunLoopCommonModes = NSRunLoopCommonModes
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
}

#pragma mark 创建一条常驻线程
-(void)longThread{
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    
    [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    [runloop run];
    
}

@end
