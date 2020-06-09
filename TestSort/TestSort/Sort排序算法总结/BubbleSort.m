//
//  BubbleSort.m
//  TestSort
//
//  Created by anfa on 2020/6/4.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "BubbleSort.h"

@implementation BubbleSort

+ (NSMutableArray *)sortWithArray:(NSMutableArray *)array{
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    NSMutableArray *resultArr = [BubbleSort bubbleSort:array];

    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    
//    NSLog(@"方法耗时: %f ms,%@",endTime * 1000.0,NSStringFromClass([self class]));
    [BubbleSort logCostTime:endTime];
    
    return resultArr;
}

+(NSMutableArray *)bubbleSort:(NSMutableArray *)tempArray{
    NSMutableArray *array = [tempArray mutableCopy];
    for (int i = 0; i < array.count; i++) {
        for (int j = i+1; j < array.count; j++) {
            if ([array[i] intValue] > [array[j] intValue]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}

@end
