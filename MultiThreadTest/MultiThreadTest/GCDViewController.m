//
//  GCDViewController.m
//  MultiThreadTest
//
//  Created by anfa on 2020/6/9.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"GCD总结";
    
    NSLog(@"mainThread------%@",[NSThread mainThread]);
    
//    [self asyncConcurrent];
    
//    [self asyncSerial];
    
//    [self syncConcurrent];

//    [self syncSerial];
    
//    [self afterAction];
    
//    [self timerAction];
    
//    [self applyAction];
    
//    [self barrierAction];
    
    [self groupAction];
}

/* GCD的步骤
 1、创建队列
 2、封装任务，把任务添加到队列
*/

//异步函数 + 并发队列
-(void)asyncConcurrent{
    dispatch_queue_t queue = dispatch_queue_create("com.anfa.queue1", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3-----%@",[NSThread currentThread]);
    });
}

//异步函数 + 串行队列
-(void)asyncSerial{
    dispatch_queue_t queue = dispatch_queue_create("com.anfa.queue2", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2-----%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3-----%@",[NSThread currentThread]);
    });
}

//同步函数 + 异步队列
-(void)syncConcurrent{
    dispatch_queue_t queue = dispatch_queue_create("com.anfa.queue3", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
}

//同步函数 + 串行队列  ---在主线程执行会死锁
-(void)syncSerial{
    dispatch_queue_t queue = dispatch_queue_create("com.anfa.queue4", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    });
}

#pragma mark 延时执行
-(void)afterAction{
    /*原理：先等两秒，再把任务提交到队列
     参数二：队列（决定block中的队列在哪个线程中执行，如果是主队列就是在主线程，否就在子线程）
    */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----GCD-----%@",[NSThread currentThread]);
    });
}

#pragma mark 定时器
-(void)timerAction{
    /*
     参数一：定时器对象
     参数二：开始时间    DISPATCH_TIME_NOW 现在开始
     参数三：间隔时间
     参数四：精准度（允许的误差）
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"--定时器--%@",[NSThread currentThread]);
    });
    
    dispatch_resume(timer);
}

#pragma mark 快速迭代
-(void)applyAction{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    /*
     1、会开启多条子线程和主线程一起并发的执行任务
     2、如果在主队列中执行会产生死锁
     3、如果在普通的串行队列：执行效果和for循环一样
     */
    dispatch_apply(10, queue, ^(size_t i) {
        NSLog(@"%zd---%@",i,[NSThread currentThread]);
    });
}

#pragma mark 栅栏函数
-(void)barrierAction{
    
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue = dispatch_queue_create("com.anfa.TestBarrier", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"1-------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2-------%@",[NSThread currentThread]);
    });
    
    /*
     ⚠️ 不能使用全局并发队列 , 使用了全局并发队列栅栏函数就失效了
     栅栏函数：前面队列的任务并发执行，后面的任务也是并发执行
     当前的任务执行完毕之后执行栅栏函数重点饿任务，等改任务执行完毕之后再执行后面的任务
     */
    dispatch_barrier_async(queue, ^{
        NSLog(@"++++++++++++++++");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3-------%@",[NSThread currentThread]);
    });
}

#pragma mark 队列组
-(void)groupAction{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue1 = dispatch_queue_create("com.anfa.queue1", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_queue_t queue2 = dispatch_queue_create("com.anfa.queue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"1----queue1-----%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"2----queue1-----%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"3----queue1-----%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue2, ^{
        NSLog(@"4----queue2-----%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue2, ^{
        NSLog(@"5----queue2-----%@",[NSThread currentThread]);
    });
    
    /*
     拦截通知:当所有的任务都执行完毕后才执行
     1、内部是异步执行
     2、多个队列的任务也可以拦截
     参数二：
     队列：决定该block在哪个线程中执行
     */
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"+++++++++++++");
    });
    
}

@end
