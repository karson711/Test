//
//  NSThreadVC.m
//  MultiThreadTest
//
//  Created by anfa on 2020/6/9.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "NSThreadVC.h"

@interface NSThreadVC ()

@end

@implementation NSThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"NSThread总结";
}

#pragma mark - 创建线程的三种方式
-(void)creatThreadMethod1{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [thread start];//线程一启动就会在thread中执行run方法

}

-(void)creatThreadMethod2{
    //创建新车后自动启动线程
    [NSThread detachNewThreadWithBlock:^{

    }];
    
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

-(void)creatThreadMethod3{
    //隐式创建并启动线程
    [self performSelectorInBackground:@selector(run) withObject:nil];
    
}

#pragma mark - 线程间通讯
-(void)run{
    NSLog(@"线程启动");
    
    UIImage *image = [[UIImage alloc] init];
    
    //方法一
    [self performSelectorOnMainThread:@selector(showImage) withObject:image waitUntilDone:YES];
    
    //方法二
    [self performSelector:@selector(showImage) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
}

-(void)showImage{
    NSLog(@"主线程中刷新图片");
}

@end
