//
//  Person.h
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/17.
//  Copyright © 2019 张波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (copy,   nonatomic) NSString *name;
@property (copy,   nonatomic) NSString *age;
@property (copy,   nonatomic) NSString *sex;

+ (instancetype)personWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
