//
//  InsertSort.m
//  TestSort
//
//  Created by anfa on 2020/6/4.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "InsertSort.h"

@implementation InsertSort

+(NSMutableArray *)sortWithArray:(NSMutableArray *)array{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    NSMutableArray *resultArr = [InsertSort insertSortArray:array];

    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);

    [InsertSort logCostTime:endTime];
    
    return resultArr;
}

+(NSMutableArray *)insertSortArray:(NSMutableArray *)tempArr
{
    NSMutableArray *array = [tempArr mutableCopy];
    if (array.count < 2 || array == nil) {
        return array;
    }
    //最外层，代表要插入第i个数。i=0 的时候，数组里面没有数据，所以应从1开始
    for (int i = 1; i < array.count; i ++) {
        //通过比较i的值 与  i 的前一个数 的大小，来判断是否需要交换
        //如果i的值比较大，则无需交换，跳出此次循环
        //如果i的值比较小，交换。 交换后继续比较 i-1 的前一个数，与 i-1 的大小
        //注意：内层循环会执行j--，故arry[i]， 要写成arry[j+1]
        for (int j = i - 1 ; j>=0  ; j--) {
            if ([array[j+1] intValue] < [array[j] intValue]) {
                int temp = [array[j] intValue];
                array[j]= array[j+1];
                array[j+1] = [NSNumber numberWithInt:temp];
//                NSLog(@"%@",array);

            }else {
                break;
            }
        }
    }
    return array;
}

@end
