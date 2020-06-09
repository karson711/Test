//
//  Person.m
//  RunTimeTest
//
//  Created by anfa on 2020/6/8.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Person


// 当一个对象调用未实现的方法，会调用这个方法处理,并且会把对应的方法列表传过来.
// 刚好可以用来判断，未实现的方法是不是我们想要动态添加的方法
+(BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(eat)) {
        //动态添加eat方法
        // 第一个参数：给哪个类添加方法
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        class_addMethod(self, @selector(eat), eat, "v@:");
    }
    
    return [super resolveInstanceMethod:sel];
}

void eat(id self,SEL sel)
{
    NSLog(@"%@ %@",self,NSStringFromSelector(sel));
}


-(void)logInfo{
    NSLog(@"姓名:%@,年龄:%d,体重:%.2lf",self.name,self.age,self.weight);
}

-(void)drink{
    NSLog(@"喝水");
}

+(void)study{
    NSLog(@"学习");
}

+(void)run{
    NSLog(@"跑步");
}

@end
