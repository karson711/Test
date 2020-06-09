//
//  Sort.h
//  TestSort
//
//  Created by anfa on 2020/6/4.
//  Copyright © 2020 anfa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sort : NSObject

+(NSMutableArray *)sortWithArray:(NSMutableArray *)array;

+(void)logCostTime:(CFAbsoluteTime)costTime;

@end

NS_ASSUME_NONNULL_END
