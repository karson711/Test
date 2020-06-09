//
//  Person.h
//  RunTimeTest
//
//  Created by anfa on 2020/6/8.
//  Copyright © 2020 anfa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) double weight;

-(void)logInfo;
-(void)drink;
+(void)study;
+(void)run;

@end

NS_ASSUME_NONNULL_END
