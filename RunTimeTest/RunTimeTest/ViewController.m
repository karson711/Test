//
//  ViewController.m
//  RunTimeTest
//
//  Created by anfa on 2020/6/8.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+runtime.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"

@interface ViewController ()

@property (nonatomic, strong) Person *p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.p = [[Person alloc] init];
    [self.p setValue:@"Kobe" forKey:@"name"];
    [self.p setValue:@28 forKey:@"age"];
    //   p.address = @"广州大学城";
    self.p.weight = 110.0f;
//    [self.p logInfo];

//    if ([self.p hasProperty:@"age"]) {
//        NSLog(@"有该属性");
//    }else{
//        NSLog(@"没有该属性");
//    }
//
//    [self printIvarPropertyMethod];
//
//    [self creatNewClass];
//
//    [self changeAge];
    
    [self exchangeInstanceMethod];
}

/*Class 其实是指向 objc_class 结构体的指针
 typedef struct objc_class *Class;
 
 struct objc_class {
   Class isa OBJC_ISA_AVAILABILITY;
 #if !__OBJC2__
   Class super_class                                       OBJC2_UNAVAILABLE;
   const char *name                                         OBJC2_UNAVAILABLE;
   long version                                             OBJC2_UNAVAILABLE;
   long info                                               OBJC2_UNAVAILABLE;
   long instance_size                                       OBJC2_UNAVAILABLE;
   struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
   struct objc_method_list **methodLists                   OBJC2_UNAVAILABLE;
   struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
   struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
 #endif
 } OBJC2_UNAVAILABLE;
 
 a. 从 objc_class 可以看到，一个运行时类中关联了它的父类指针、类名、成员变量、方法、缓存以及附属的协议
 */
#pragma mark - RunTime实际应用
#pragma mark 打印一个类的所有ivar,property和method
-(void)printIvarPropertyMethod{
    
    
    /* Ivar 是表示成员变量的类型
     typedef struct objc_ivar *Ivar;
     struct objc_ivar {
       char *ivar_name                                         OBJC2_UNAVAILABLE;
       char *ivar_type                                         OBJC2_UNAVAILABLE;
       int ivar_offset                                         OBJC2_UNAVAILABLE;
     #ifdef __LP64__
       int space                                               OBJC2_UNAVAILABLE;
     #endif
     }
     */
    //1、打印所有ivars
    unsigned int ivarCount = 0;
    //用一个字典装ivarName和value
    NSMutableDictionary *ivarDict = [NSMutableDictionary dictionary];
    Ivar *ivarList = class_copyIvarList([self.p class], &ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivarList[i])];
        id value = [self.p valueForKey:ivarName];
        
        if (value) {
            ivarDict[ivarName] = value;
        } else {
            ivarDict[ivarName] = @"值为nil";
        }
        
    }
    
    for (NSString *ivarName in ivarDict.allKeys) {
        NSLog(@"ivarName:%@, ivarValue:%@",ivarName, ivarDict[ivarName]);
    }
    
    
    //2、打印所有的properties
    unsigned int propertyCount = 0;
    // 用一个字典装propertyName和value
    NSMutableDictionary *propertyDict = [NSMutableDictionary dictionary];
    objc_property_t *propertyList = class_copyPropertyList([self.p class], &propertyCount);
    for(int j = 0; j < propertyCount; j++){
      NSString *propertyName = [NSString stringWithUTF8String:property_getName(propertyList[j])];
      id value = [self.p valueForKey:propertyName];
    
      if (value) {
          propertyDict[propertyName] = value;
      } else {
          propertyDict[propertyName] = @"值为nil";
      }
    }
    // 打印property
    for (NSString *propertyName in propertyDict.allKeys) {
      NSLog(@"propertyName:%@, propertyValue:%@",propertyName, propertyDict[propertyName]);
    }
    
    
    /*Method 代表类中某个方法的类型
     typedef struct objc_method *Method;
     
     struct objc_method {
       SEL method_name                                         OBJC2_UNAVAILABLE;
       char *method_types                                       OBJC2_UNAVAILABLE;
       IMP method_imp                                           OBJC2_UNAVAILABLE;
     }
     a.方法名类型为 SEL
     b.方法类型 method_types 是个 char 指针，存储方法的参数类型和返回值类型
     c.method_imp 指向了方法的实现，本质是一个函数指针
     */
    //3、打印所有的methods
    unsigned methodCount = 0;
    NSMutableDictionary *methodDict = [NSMutableDictionary dictionary];
    Method *methodList = class_copyMethodList([self.p class], &methodCount);
    for (int k = 0; k < methodCount; k++) {
        SEL methodSel = method_getName(methodList[k]);
        NSString *methodName = [NSString stringWithUTF8String:sel_getName(methodSel)];
        
        unsigned int argumentNums = method_getNumberOfArguments(methodList[k]);
        
        methodDict[methodName] = @(argumentNums - 2);// 减2的原因是每个方法内部都有self 和 selector 两个参数
        
    }
    //打印method
    for (NSString *methodName in methodDict.allKeys) {
        NSLog(@"methodName:%@, argumentsCount:%@", methodName, methodDict[methodName]);
    }
    
}


#pragma mark 动态添加一个类
-(void)creatNewClass{
    // 创建一个类(size_t extraBytes该参数通常指定为0, 该参数是分配给类和元类对象尾部的索引ivars的字节数。)
    Class clazz = objc_allocateClassPair([Person class], "GoodPerson", 0);
    
    // 添加ivar
    // @encode(aType) : 返回该类型的C字符串
    class_addIvar(clazz, "_address", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    
    class_addIvar(clazz, "_sex", sizeof(NSUInteger), log2(sizeof(NSUInteger)), @encode(NSUInteger));
    
    // 注册该类
    objc_registerClassPair(clazz);
    
    
    // 创建实例对象
    id object = [[clazz alloc]init];
    
    // 设置ivar
    [object setValue:@"kunge" forKey:@"name"];
    
    Ivar ageIvar = class_getInstanceVariable(clazz, "_age");
    object_setIvar(object, ageIvar, @28);
    
    NSLog(@"%@",object);
    
}

#pragma mark 动态变量控制
-(void)changeAge{
    unsigned int count = 0;
    //动态获取p类中的所有属性【包括私有属性】
    Ivar *ivarList = class_copyIvarList([self.p class], &count);
    
    //遍历所有属性找到对应age字段
    for (int i = 0; i < count; i++) {
        Ivar var = ivarList[i];
        const char *ivarName = ivar_getName(var);
        NSString *name = [NSString stringWithUTF8String:ivarName];
        if ([name isEqualToString:@"_age"]) {
            //修改对应字段值为18
            object_setIvar(self.p, var, @18);
            break;
        }
    }
    NSLog(@"p的age值为 %d",self.p.age);
}

#pragma mark 方法交换(类方法)
-(void)exchangeClassMethod{
    //获取两个类方法
    Method m1 = class_getClassMethod([Person class], @selector(run));
    Method m2 = class_getClassMethod([Person class], @selector(study));
    
    //开始交换方法实现
    method_exchangeImplementations(m1, m2);
    
    //交换后，先打印学习，再打印跑步
    [Person run];
    [Person study];
}

#pragma mark 方法交换(实例方法)
-(void)exchangeInstanceMethod{
    Method m1 = class_getInstanceMethod([self.p class], @selector(logInfo));
    Method m2 = class_getInstanceMethod([self.p class], @selector(drink));
    
    method_exchangeImplementations(m1, m2);
    
    [self.p logInfo];
    [self.p drink];
}

@end
