//
//  NSOperationVC.m
//  MultiThreadTest
//
//  Created by anfa on 2020/6/9.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "NSOperationVC.h"

@interface NSOperationVC ()

@end

@implementation NSOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"NSOperation总结";
    
//    [self invocationOperationWithQueue];
    
//    [self blockOperationWithQueue];
    
    [self depencyAction];
}

#pragma mark NSInvocaitonOperation
-(void)invocationOperationWithQueue{
    //1、创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //2、封装操作
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download1) object:nil];
    
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download2) object:nil];
    
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download3) object:nil];
    
    //3、把操作添加到队列
    [queue addOperation:op1];//该方法内部会自动调用start方法执行任务
    [queue addOperation:op2];
    [queue addOperation:op3];
    
}

-(void)download1{
    NSLog(@"1-----%@",[NSThread currentThread]);
}

-(void)download2{
    NSLog(@"2-----%@",[NSThread currentThread]);
}

-(void)download3{
    NSLog(@"3-----%@",[NSThread currentThread]);
}

#pragma mark NSBlockOperation
-(void)blockOperationWithQueue{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2-----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3-----%@",[NSThread currentThread]);
    }];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    //简便方法：该方法内部首先会把block中的任务封装成一个操作(Operation),然后把该操作直接添加到队列
    [queue addBarrierBlock:^{
        NSLog(@"4-----%@",[NSThread currentThread]);
    }];
    
    //追加任务
    [op3 addExecutionBlock:^{
        NSLog(@"5-----%@",[NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"6-----%@",[NSThread currentThread]);
    }];
}

#pragma mark 操作依赖和监听
-(void)depencyAction{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1-----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2-----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3-----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4-----%@",[NSThread currentThread]);
    }];
    
    /*
     ⚠️不能设置循环依赖，如果设置循环依赖，结果就是循环的任务不会执行
     1、操作依赖可以设置跨队列依赖
     */
    //设置操作依赖：4->3->2->1
    [op1 addDependency:op2];
    [op2 addDependency:op3];
    [op3 addDependency:op4];

    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    
    //监听任务执行完毕
    op4.completionBlock = ^{
        NSLog(@"主人，你的电影已下载好了，快来观看吧");
    };
}


@end
