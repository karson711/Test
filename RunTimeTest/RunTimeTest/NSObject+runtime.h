//
//  NSObject+runtime.h
//  RunTimeTest
//
//  Created by anfa on 2020/6/8.
//  Copyright © 2020 anfa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (runtime)

//判断类中是否有该属性
-(BOOL)hasProperty:(NSString *)property;

@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
