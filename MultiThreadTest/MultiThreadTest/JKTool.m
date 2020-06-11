//
//  JKTool.m
//  MultiThreadTest
//
//  Created by anfa on 2020/6/11.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "JKTool.h"

@implementation JKTool

/* 方法一
 把其可能出现的初始化方法做了相应的处理来其保证安全性
 */

//1、提供类方法
+(instancetype)shareTool{
    //1、提供一个全局的静态变量(对外界隐藏)
    //staic修饰的静态变量生命周期是程序启动就存在，直到程序退出才会被释放
    static JKTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

//2、重写alloc方法，保证方法永远只分配一次存储空间
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [JKTool shareTool];
}

//3、重写copy
-(id)copyWithZone:(NSZone *)zone{
    return [JKTool shareTool];
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return [JKTool shareTool];
}

/*
 方法二
 更简便的方法是在不做处理的情况下 禁止外部调用
 
 在.h文件中声明下面的方法
 - (instancetype)init NS_UNAVAILABLE;
 + (instancetype)new NS_UNAVAILABLE;
 - (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
 - (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
 
 在.m中实现方法有一点不一样
 +(instancetype)shareTool{
     //1、提供一个全局的静态变量(对外界隐藏)
     //staic修饰的静态变量生命周期是程序启动就存在，直到程序退出才会被释放
     static JKTool *_instance = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         // 要使用self来调用
         _instance = [[self alloc] init];
     });
     return _instance;
 }
 
 */


@end
