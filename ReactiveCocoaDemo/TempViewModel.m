//
//  TempViewModel.m
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/14.
//  Copyright © 2019 张波. All rights reserved.
//

#import "TempViewModel.h"

@implementation TempViewModel

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		//	登录请求逻辑
		[self setupLoginCommand];
	}
	return self;
}

- (void)setupLoginCommand
{
	@weakify(self);
	self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
		@strongify(self);
		return [self loginRequestData];
	}];
	[[self.loginCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
		NSLog(@"%@", x);
	}];
}

- (RACSignal *)loginRequestData
{
	return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		NSLog(@"登录中...");
		[NSThread sleepForTimeInterval:5];
		[subscriber sendNext:@"登录成功!"];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
