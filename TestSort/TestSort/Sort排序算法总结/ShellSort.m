//
//  ShellSort.m
//  TestSort
//
//  Created by anfa on 2020/6/5.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "ShellSort.h"

@implementation ShellSort

+ (NSMutableArray *)sortWithArray:(NSMutableArray *)array{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    NSMutableArray *resultArr = [array mutableCopy];
    [ShellSort shellSort:resultArr];

    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);

    [ShellSort logCostTime:endTime];
    
    return resultArr;
}

//起始间隔值gap设置为总数的一半，直到gap==1结束
+(void)shellSort:(NSMutableArray *)list{
    int gap = (int)list.count / 2;
    while (gap >= 1) {
        for(int i = gap ; i < [list count]; i++){
            NSInteger temp = [[list objectAtIndex:i] intValue];
            int j = i;
            while (j >= gap && temp < [[list objectAtIndex:(j - gap)] intValue]) {
                [list replaceObjectAtIndex:j withObject:[list objectAtIndex:j-gap]];
                j -= gap;
            }
            [list replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:temp]];
        }
        gap = gap / 2;
    }
}

@end
