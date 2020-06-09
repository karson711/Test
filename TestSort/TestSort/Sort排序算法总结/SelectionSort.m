//
//  SelectionSort.m
//  TestSort
//
//  Created by anfa on 2020/6/4.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "SelectionSort.h"

@implementation SelectionSort

+ (NSMutableArray *)sortWithArray:(NSMutableArray *)array{
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    NSMutableArray *resultArr = [SelectionSort selectSort:array];

    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);

    [SelectionSort logCostTime:endTime];
    
    return resultArr;
}

//选择排序
//每次把最大的选出来 放到前面，然后依次类推
+(NSMutableArray *)selectSort:(NSMutableArray *)tempArray
{
    NSMutableArray *array = [tempArray mutableCopy];
    if (!array || array.count == 1)
    {
        return array;
    }
    NSMutableArray *sortResult = [NSMutableArray arrayWithArray:array];
    NSInteger flag;
    NSInteger execCount = 0;//交换次数
    NSInteger forCount = 0;//for循环总共执行了多少次
    for (NSInteger i = 0; i < sortResult.count; i++)
    {
        flag = i;
        forCount++;
        for (NSInteger j = i; j < sortResult.count - 1; j++)
        {
            if (sortResult[j + 1] > sortResult[flag])
            {
                flag = j + 1;
            }
            forCount++;
        }
        if (i != flag)
        {
            [sortResult exchangeObjectAtIndex:i withObjectAtIndex:flag];
            execCount++;
            [SelectionSort displayArray:sortResult];
        }
    }
//    NSLog(@"交换共执行了%ld次", execCount);
//    NSLog(@"for循环共执行了%ld次", forCount);
    return sortResult;
}

+(void)displayArray:(NSMutableArray *)array
{
    NSMutableString *displayString = [NSMutableString stringWithString:@"["];
    for (NSInteger i = 0; i < array.count; i++)
    {
        i == array.count - 1 ? [displayString appendString:[NSString stringWithFormat:@"%ld", (long)[array[i] integerValue]]] :[displayString appendString:[NSString stringWithFormat:@"%ld%@", (long)[array[i] integerValue], @","]];
    }
    [displayString appendString:@"]"];
//    NSLog(@"%@", displayString);
}

@end
