//
//  LoginViewModel.m
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/19.
//  Copyright © 2019 张波. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		//	将图片的变量与userName的属性变化进行绑定
		//	同时根据userName的变化自定义规则映射出iconUrl的地址
		//	distinctUntilChanged避免重复发送相同信号
		NSLog(@"输入1，12，123可以切换不同头像");
		RAC(self, iconUrl) = [[[RACObserve(self, userName) skip:1] map:^id _Nullable(id  _Nullable value) {
			NSLog(@"value:%@", [NSString stringWithFormat:@"http:%@", value]);
			//	自定义映射返回的value值，可以a在这里做数据库操作、网络请求等等
			return [NSString stringWithFormat:@"http:%@", value];
		}] distinctUntilChanged];
		
		//	组合信号，监听userName和pwd的属性，以改变login的颜色属性
		self.loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, userName), RACObserve(self, pwd)] reduce:^id (NSString *userName, NSString *pwd){
			NSLog(@"userName:%@, pwd:%@", userName, pwd);
			return @(userName.length > 0 && pwd.length > 0);
		}];
		//	登录请求逻辑
		[self setupLoginCommand];
		//	状态文字信号
		self.statusSubject = [RACSubject subject];
		self.isLogining = NO;
	}
	return self;
}

- (void)setupLoginCommand
{
	@weakify(self);
	self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
		@strongify(self);
		//	请求登录网络封装
		return [self loginRequestData];
	}];
	
	[[self.loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
		NSLog(@"executing:%@", x);
		@strongify(self);
		//	根据是否正在执行，可以在此处进行UI展示操作
		if (x.boolValue)
		{
			[self statusLabelAnimation];
		}
	}];
	
	[[self.loginCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
		NSLog(@"executionSignals:%@", x);
		//	注意：executionSignals必须放在主线程中，block中的操作也需要放入主线程中执行。
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.statusSubject sendNext:@"登录成功!"];
			self.isLogining = NO;
		});
	}];
	
	[self.loginCommand.errors subscribeNext:^(NSError * _Nullable x) {
		NSLog(@"error:%@", x);
		//	errors也建议放入主线程中，尽管不放入主线程也不会报错，与executionSignals不同。查看errors的代码会发现，errors被封装到RACMulticastConnection对象中，没有进行replay操作，映射的信号当catch到error时，
		//	会直接返回error；当没有catcha到时，subject会重新回到主线程中重新规划内存。
		[self.statusSubject sendNext:@"登录失败"];
		self.isLogining = NO;
	}];
}

- (RACSignal *)loginRequestData
{
	@weakify(self);
	return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		@strongify(self);
		//	请求网络相关代码写在这里
		//	模拟网络操作，延迟10秒执行并判断业务逻辑
		dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_queue_t main_queue = dispatch_get_main_queue();
		dispatch_async(global_queue, ^{
			[NSThread sleepForTimeInterval:10];
			dispatch_async(main_queue, ^{
				if ([self.userName isEqualToString:@"123"] && [self.pwd isEqualToString:@"123"])
				{
					[subscriber sendNext:@"登录成功!"];
					[subscriber sendCompleted];
				} else
				{
					NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:1003 userInfo:@{@"msg":@"登录失败!"}];
					[subscriber sendError:error];
				}
			});
		});
		return nil;
	}];
}

- (void)statusLabelAnimation
{
	self.isLogining = YES;
	__block int num = 0;
	[[[[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] map:^id _Nullable(NSDate * _Nullable value) {
		NSLog(@"登录时间:%@", value);
		num+=1;
		int count = num % 3;
		NSString *statusStr = @"登录中，请稍后";
		switch (count) {
			case 0:
			{
				statusStr = @"登录中，请稍后.";
			}
				break;
			case 1:
			{
				statusStr = @"登录中，请稍后..";
			}
				break;
			case 2:
			{
				statusStr = @"登录中，请稍后...";
			}
				break;
			default:
				break;
		}
		return statusStr;
	}] takeUntilBlock:^BOOL(id  _Nullable x) {
		return num >= 20 || !self.isLogining;
	}] subscribeNext:^(id  _Nullable x) {
		NSLog(@"subscribeNext:%@", x);
		//	状态信号发送订阅信号
		[self.statusSubject sendNext:x];
	}];
}

@end
