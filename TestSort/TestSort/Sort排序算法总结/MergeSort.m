//
//  MergeSort.m
//  TestSort
//
//  Created by anfa on 2020/6/4.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "MergeSort.h"

@implementation MergeSort

+(NSMutableArray *)sortWithArray:(NSMutableArray *)array{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    NSMutableArray *resultArr = [self megerSortAscendingOrderSort:array];

    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);

    [MergeSort logCostTime:endTime];
   
    return resultArr;
}

+ (NSMutableArray *)megerSortAscendingOrderSort:(NSMutableArray *)ascendingArr
{
    //tempArray数组里存放ascendingArr个数组，每个数组包含一个元素
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    for (NSNumber *num in ascendingArr) {
        NSMutableArray *subArray = [NSMutableArray array];
        [subArray addObject:num];
        [tempArray addObject:subArray];
    }
    //开始合并为一个数组
    while (tempArray.count != 1) {
        NSInteger i = 0;
        while (i < tempArray.count - 1) {
            tempArray[i] = [MergeSort mergeArrayFirstList:tempArray[i] secondList:tempArray[i + 1]];
            [tempArray removeObjectAtIndex:i + 1];
            i++;
        }
    }
//    NSLog(@"归并升序排序结果：%@", tempArray[0]);
    return tempArray[0];
}
 
+ (NSArray *)mergeArrayFirstList:(NSArray *)array1 secondList:(NSArray *)array2 {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSInteger firstIndex = 0, secondIndex = 0;
    while (firstIndex < array1.count && secondIndex < array2.count) {
        if ([array1[firstIndex] floatValue] < [array2[secondIndex] floatValue]) {
            [resultArray addObject:array1[firstIndex]];
            firstIndex++;
        } else {
            [resultArray addObject:array2[secondIndex]];
            secondIndex++;
        }
    }
    while (firstIndex < array1.count) {
        [resultArray addObject:array1[firstIndex]];
        firstIndex++;
    }
    while (secondIndex < array2.count) {
        [resultArray addObject:array2[secondIndex]];
        secondIndex++;
    }
    return resultArray.copy;
}

@end
