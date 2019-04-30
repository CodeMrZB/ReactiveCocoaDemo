//
//  TempView.m
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/13.
//  Copyright © 2019 张波. All rights reserved.
//

#import "TempView.h"
#include <stdio.h>

@implementation TempView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		NSLog(@"%s", __func__);
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	NSLog(@"%s", __func__);
}

- (IBAction)itemClick:(UIButton *)item
{
	//	数据改变时--->信号发送改变的信息--->通知信号订阅者执行方法
	[self.itemClickSubject sendNext:@(item.tag - 1000)];
}

#pragma mark - Getter
- (RACSubject *)itemClickSubject
{
	if (!_itemClickSubject)
	{
		_itemClickSubject = [RACSubject subject];
	}
	return _itemClickSubject;
}

@end
