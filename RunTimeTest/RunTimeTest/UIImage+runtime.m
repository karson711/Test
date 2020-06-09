//
//  UIImage+runtime.m
//  RunTimeTest
//
//  Created by anfa on 2020/6/8.
//  Copyright © 2020 anfa. All rights reserved.
//

#import "UIImage+runtime.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIImage (runtime)

+(void)load{
    Method m1 = class_getClassMethod([UIImage class], @selector(imageNamed:));
    Method m2 = class_getClassMethod([UIImage class], @selector(jk_imageNamed:));
    
    method_exchangeImplementations(m1, m2);
}

+(UIImage *)jk_imageNamed:(NSString *)name{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version >= 11.0) {
        // 如果系统版本是11.0以上，使用另外一套文件名结尾是‘_os11’的扁平化图片
        name = [name stringByAppendingString:@"_os11"];
    }
    return [UIImage jk_imageNamed:name];
}


@end
