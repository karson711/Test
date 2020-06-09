//
//  Sort.m
//  TestSort
//
//  Created by anfa on 2020/6/4.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "Sort.h"

@interface Sort ()

@end

@implementation Sort

+(void)logCostTime:(CFAbsoluteTime)costTime{
    NSLog(@"方法耗时: %f ms--%@",costTime * 1000.0,NSStringFromClass([self class]));
}

@end
