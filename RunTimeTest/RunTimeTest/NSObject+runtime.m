//
//  NSObject+runtime.m
//  RunTimeTest
//
//  Created by anfa on 2020/6/8.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "NSObject+runtime.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (runtime)

/* 关联对象
1、 void objc_setAssociatedObject(id object , const void *key ,id value ,objc_AssociationPolicy policy)
    
 set方法，将值value 跟对象object 关联起来（将值value 存储到对象object 中）
 参数一 object：给哪个对象设置属性
 参数二 key：一个属性对应一个Key，将来可以通过key取出这个存储的值，key 可以是任何类型：double、int 等，建议用char 可以节省字节
 参数三 value：给属性设置的值
 参数policy：存储策略 （assign 、copy 、 retain就是strong）属性以什么形式保存
 策略有有以下几种
 typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
     OBJC_ASSOCIATION_ASSIGN = 0,  // 指定一个弱引用相关联的对象
     OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, // 指定相关对象的强引用，非原子性
     OBJC_ASSOCIATION_COPY_NONATOMIC = 3,  // 指定相关的对象被复制，非原子性
     OBJC_ASSOCIATION_RETAIN = 01401,  // 指定相关对象的强引用，原子性
     OBJC_ASSOCIATION_COPY = 01403     // 指定相关的对象被复制，原子性
 };
 
2、 id objc_getAssociatedObject(id object , const void *key)
    
 利用参数key 将对象object中存储的对应值取出来，key值只要是一个指针即可，我们可以传入@selector(name)
 参数一：id object : 获取哪个对象里面的关联的属性。
 参数二：void * == id key : 什么属性，与objc_setAssociatedObject中的key相对应，即通过key值取出value。

 */
-(void)setName:(NSString *)name{
    // 将某个值跟某个对象关联起来，将某个值存储到某个对象中
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)name{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)removeAssociatedObjects{
    // 移除所有关联对象
    objc_removeAssociatedObjects(self);
}

#pragma mark 判断类中是否有该属性
-(BOOL)hasProperty:(NSString *)property {
  BOOL flag = NO;
  u_int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
  for (int i = 0; i < count; i++) {
      const char *propertyName = property_getName(propertyList[i]);
      NSString *propertyString = [NSString stringWithUTF8String:propertyName];
      if ([propertyString isEqualToString:property]){
          flag = YES;
      }
  }
  return flag;
}

@end
