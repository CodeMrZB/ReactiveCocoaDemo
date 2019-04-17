//
//  Person.m
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/17.
//  Copyright © 2019 张波. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initPersonWithDic:(NSDictionary *)dic
{
	self = [super init];
	if (self)
	{
		[self setValuesForKeysWithDictionary:dic];
	}
	return self;
}

+ (instancetype)personWithDic:(NSDictionary *)dic
{
	return [[self alloc] initPersonWithDic:dic];
}

@end
