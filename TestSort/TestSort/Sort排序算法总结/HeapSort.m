//
//  HeapSort.m
//  TestSort
//
//  Created by anfa on 2020/6/4.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "HeapSort.h"

@implementation HeapSort

+(NSMutableArray *)sortWithArray:(NSMutableArray *)array{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    NSMutableArray *resultArr = [HeapSort heapSort:array];

    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);

    [HeapSort logCostTime:endTime];
    
    return resultArr;
}

+ (NSMutableArray *)heapSort:(NSMutableArray *)tempArray
{
    NSMutableArray *list = [tempArray mutableCopy];
    NSInteger i ,size;
    size = list.count;
    //找出最大的元素放到堆顶
    for (i= list.count/2-1; i>=0; i--) {
        [HeapSort createBiggesHeap:list withSize:size beIndex:i];
    }
    
    while(size > 0){
        [list exchangeObjectAtIndex:size-1 withObjectAtIndex:0]; //将根(最大) 与数组最末交换
        size -- ;//树大小减小
        [HeapSort createBiggesHeap:list withSize:size beIndex:0];
    }
//    NSLog(@"%@",list);
    return list;
}

+ (void)createBiggesHeap:(NSMutableArray *)list withSize:(NSInteger) size beIndex:(NSInteger)element
{
    NSInteger lchild = element *2 + 1,rchild = lchild+1; //左右子树
    while (rchild < size) { //子树均在范围内
        if ([list[element] integerValue] >= [list[lchild] integerValue] && [list[element] integerValue] >= [list[rchild]integerValue]) return; //如果比左右子树都大，完成整理
        if ([list[lchild] integerValue] > [list[rchild] integerValue]) { //如果左边最大
            [list exchangeObjectAtIndex:element withObjectAtIndex:lchild]; //把左面的提到上面
            element = lchild; //循环时整理子树
        }else{//否则右面最大
            [list exchangeObjectAtIndex:element withObjectAtIndex:rchild];
            element = rchild;
        }
        
        lchild = element * 2 +1;
        rchild = lchild + 1; //重新计算子树位置
    }
    //只有左子树且子树大于自己
    if (lchild < size && [list[lchild] integerValue] > [list[element] integerValue]) {
        [list exchangeObjectAtIndex:lchild withObjectAtIndex:element];
    }
}

@end
