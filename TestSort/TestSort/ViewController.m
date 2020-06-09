//
//  ViewController.m
//  TestSort
//
//  Created by anfa on 2020/6/4.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "ViewController.h"
#import "MergeSort.h"
#import "InsertSort.h"
#import "HeapSort.h"
#import "BubbleSort.h"
#import "SelectionSort.h"
#import "QuickSort.h"
#import "ShellSort.h"


#define numMax 1000

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *needSortArray;

@end

@implementation ViewController

-(NSMutableArray *)needSortArray{
    if (!_needSortArray) {
        _needSortArray = [NSMutableArray array];
        for (int i = 0; i < numMax; i++) {
             int x =( arc4random() % numMax);
            [_needSortArray addObject:@(x)];
        }
    }
    return _needSortArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.needSortArray = [NSMutableArray arrayWithArray:@[@10,@5,@4,@20,@12,@3,@35,@13,@2,@6,@7,@8,@9,@11,@23,@25,@19,@30]];
//    [self quickSortArray:self.needSortArray withLowIndex:0 andHighIndex:self.needSortArray.count-1];
//    NSLog(@"self.needSortArray---排序后的结果------%@",[ShellSort sortWithArray:self.needSortArray] );
        
    [BubbleSort sortWithArray:self.needSortArray];
    [SelectionSort sortWithArray:self.needSortArray];
    [InsertSort sortWithArray:self.needSortArray];
    [HeapSort sortWithArray:self.needSortArray];
    [MergeSort sortWithArray:self.needSortArray];
    [QuickSort sortWithArray:self.needSortArray];
    [ShellSort sortWithArray:self.needSortArray];
}



@end
