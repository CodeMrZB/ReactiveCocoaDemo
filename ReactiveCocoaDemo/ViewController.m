//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/13.
//  Copyright © 2019 张波. All rights reserved.
//

#import "ViewController.h"
#import "TempView.h"
#import "TempViewModel.h"
#import "Person.h"
#import <RACReturnSignal.h>

@interface ViewController ()
<
	UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *textItem;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet TempView *tempView;
@property (strong, nonatomic) TempViewModel *tempViewModel;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view
	
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	self.testLabel.text = [NSString stringWithFormat:@"%d", arc4random() % (100 - 2 + 1) + 2];
	[self timeout];
}

- (void)timeout
{
	[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		return nil;
	}] timeout:2 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
		NSLog(@"x:%@", x);
	} error:^(NSError * _Nullable error) {
		NSLog(@"error:%@", error);
	}];
}

- (void)delay
{
	
}

- (void)skip
{
	[[self.textField.rac_textSignal skip:1] subscribeNext:^(NSString * _Nullable x) {
		NSLog(@"x:%@", x);
	}];
}

- (void)bind
{
	[[self.textField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
		return ^RACSignal *(id value, BOOL *stop) {
			return [RACSignal return:[NSString stringWithFormat:@"输出:%@", value]];
		};
	}] subscribeNext:^(id  _Nullable x) {
		NSLog(@"%@", x);
	}];
}

- (void)flattenMap
{
	[[self.textField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
		return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@", value]];
	}] subscribeNext:^(id  _Nullable x) {
		NSLog(@"%@", x);
	}];
}

- (void)map
{
	[[self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
		return [NSString stringWithFormat:@"输出:%@", value];
	}] subscribeNext:^(id  _Nullable x) {
		NSLog(@"%@", x);
	}];
}

- (void)flattenMapSignals
{
	RACSubject *subject = [RACSubject subject];
	RACSubject *signal = [RACSubject subject];
	[[subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
		return value;
	}] subscribeNext:^(id  _Nullable x) {
		NSLog(@"%@", x);
	}];
	[subject sendNext:signal];
	[signal sendNext:@"1"];
}

- (void)bind1
{
	[self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
		NSLog(@"输出：%@", x);
	}];
}

- (void)tupleUnpack
{
	RACTuple *tuple = RACTuplePack(@"张三", @"18");
	RACTupleUnpack(NSString *name, NSString *age) = tuple;
	NSLog(@"name:%@, age:%@", name, age);
}

- (void)tuple
{
	RACTuple *tuple = RACTuplePack(@"1", @"2", @"3", @"4", @"张三");
	NSLog(@"tuple:%@", tuple);
}

- (void)racObserve
{
	RAC(self.testLabel, text) = self.textField.rac_textSignal;
	[RACObserve(self.testLabel, text) subscribeNext:^(id  _Nullable x) {
		NSLog(@"text:%@",x);
	}];
}

- (void)convertDicToModel1
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
	NSArray *datas = [NSArray arrayWithContentsOfFile:filePath];
	NSMutableArray *persons = [NSMutableArray array];
	for (NSDictionary *dic in datas)
	{
		Person *p = [Person personWithDic:dic];
		[persons addObject:p];
	}
}

- (void)convertDicToModel2
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
	NSArray *datas = [NSArray arrayWithContentsOfFile:filePath];
	__block NSMutableArray *persons = [NSMutableArray array];
	[datas.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
		Person *p = [Person personWithDic:x];
		[persons addObject:p];
	}];
	
}

- (void)convertDicToModel3
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
	NSArray *datas = [NSArray arrayWithContentsOfFile:filePath];
	NSArray *persons = [[datas.rac_sequence map:^id _Nullable(id  _Nullable value) {
		return [Person personWithDic:value];
	}] array];
	NSLog(@"persons:%@", persons);
}

- (void)sequence
{
    NSDictionary *dic = @{@"name":@"上海", @"age":@18, @"sex":@"男"};
    [dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"key:%@, value:%@", key, value);
    }];
}

- (void)takeUntil
{
    RACSubject *subject = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [[subject takeUntil:signal] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [signal sendCompleted];
    [subject sendNext:@"3"];
}

- (void)takeLast
{
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendCompleted];
}

- (void)take
{
    RACSubject *subject = [RACSubject subject];
    [[subject take:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
}

- (void)liftSelector
{
	RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		NSLog(@"开始任务1");
		[NSThread sleepForTimeInterval:1];
		[subscriber sendNext:@"1"];
        [subscriber sendCompleted];
		NSLog(@"完成任务1");
        return [RACDisposable disposableWithBlock:^{
            
        }];
	}];
	RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		NSLog(@"开始任务2");
		[NSThread sleepForTimeInterval:1];
		[subscriber sendNext:@"2"];
		NSLog(@"完成任务2");
		return nil;
	}];
	RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		NSLog(@"开始任务3");
		[NSThread sleepForTimeInterval:1];
		[subscriber sendNext:@"3"];
		NSLog(@"完成任务3");
		return nil;
	}];
	[self rac_liftSelector:@selector(requestDataDone:str2:str3:) withSignalsFromArray:@[signal1,signal2,signal3]];
}

- (void)requestDataDone:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3
{
	NSLog(@"str1:%@----str2:%@---str3:%@", str1, str2, str3);
}

- (void)RACMacro
{
	RAC(self.testLabel, text) = self.textField.rac_textSignal;
	[RACObserve(self.testLabel, text) subscribeNext:^(id  _Nullable x) {
		NSLog(@"x:%@", x);
	}];
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
		NSLog(@"%@", x);
	}];
}

- (void)tempViewDemo
{
	@weakify(self);
	[[self.tempView rac_signalForSelector:NSSelectorFromString(@"itemClick")] subscribeNext:^(RACTuple * _Nullable x) {
		NSLog(@"点击了按钮");
		@strongify(self);
		[self.tempViewModel.loginCommand execute:@"登录操作"];
	}];
}

- (void)distinctUntilChanged
{
	//	创建信号
	RACSubject *subject = [RACSubject subject];
	//	订阅信号
	[[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
		NSLog(@"x:%@", x);
	}];
	//	发送信号
	[subject sendNext:@"123456"];
	[subject sendNext:@"张波"];
	[subject sendNext:@"张波"];
}

- (void)ignore
{
	[[self.textField.rac_textSignal ignore:@"567"] subscribeNext:^(NSString * _Nullable x) {
		NSLog(@"x:%@", x);
	}];
}

- (void)ignoreValues
{
	[[self.textField.rac_textSignal ignoreValues] subscribeNext:^(id  _Nullable x) {
		NSLog(@"x:%@", x);
	}];
}

- (void)filter
{
	@weakify(self);
	[[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
		//	过滤判断条件
		@strongify(self);
		if (value.length >= 6)
		{
			self.textField.text = [value substringToIndex:6];
			self.testLabel.text = @"已经到6位了";
			self.testLabel.textColor = [UIColor blueColor];
		}
		return value.length <= 6;
	}] subscribeNext:^(NSString * _Nullable x) {
		//	订阅逻辑区域
		NSLog(@"x:%@", x);
	}];
}

- (void)map1
{
	//	[[self.textField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
	//		return [RACSignal return:[NSString stringWithFormat:@"自定义了返回值:%@", value]];
	//	}] subscribeNext:^(id  _Nullable x) {
	//		NSLog(@"x:%@", x);
	//	}];
	
	[[self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
		return [NSString stringWithFormat:@"自定义了返回信号:%@", value];
	}] subscribeNext:^(id  _Nullable x) {
		NSLog(@"x:%@", x);
	}];
}

- (void)RACBase
{
	//	创建信号
	RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		//	发送信号
		[subscriber sendNext:@"send a message"];
		[subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:1001 userInfo:@{@"errorMsg": @"this is a error message"}]];
		//	销毁信号
		return [RACDisposable disposableWithBlock:^{
			NSLog(@"signal信号已销毁");
		}];
	}];
	
	//	订阅信号
	[signal subscribeNext:^(id  _Nullable x) {
		NSLog(@"x:%@", x);
	}];
	
	[signal subscribeError:^(NSError * _Nullable error) {
		NSLog(@"error:%@", error);
	}];
}

- (void)enumerator
{
	//	遍历数组
//	NSArray *items = @[@"张三", @"李四", @"额昂无", @"2", @"rt"];
//	[items.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
//		NSLog(@"x:%@", x);
//	}];
	
	//	遍历字典
	NSDictionary *dic = @{@"name":@"张三", @"age":@"18", @"sex":@"女", @"leavel":@39};
	[dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
		RACTwoTuple *tuple = (RACTwoTuple *)x;
		NSLog(@"key:%@---value:%@", tuple[0], tuple[1]);
        //  RACTupleUnpack解包元祖，把元祖的数据，按顺序给参数里的变量赋值
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"key:%@, value:%@", key, value);
	}];
}

- (void)timer
{
//	[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
//		NSLog(@"x:%@----thread:%@", x, [NSThread currentThread]);
//	}];
	
	RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault name:@"com.xg.rac"];
	[[RACSignal interval:5 onScheduler:scheduler] subscribeNext:^(NSDate * _Nullable x) {
		NSLog(@"x:%@----thread:%@", x, [NSThread currentThread]);
	}];
}

- (void)notification
{
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
		NSLog(@"x:%@", x);
	}];
}

- (void)KVO_method
{
	[self.testLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"text"] && object == self.testLabel)
	{
		NSLog(@"changge:%@", change);
	}
}


- (void)delegate
{
	[[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
		NSLog(@"x:%@", x);
	}];
	self.textField.delegate = self;
}

- (void)KVO
{
	[RACObserve(self.testLabel, text) subscribeNext:^(id  _Nullable x) {
		NSLog(@"x:%@", x);
	}];
	
	[[self.testLabel rac_valuesAndChangesForKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
		NSLog(@"x:%@", x);
	}];
}

- (void)button
{
	[[self.textItem rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
		NSLog(@"点击了按钮---%@", x);
	}];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
	[self.testLabel addGestureRecognizer:tap];
	self.testLabel.userInteractionEnabled = YES;
	[tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
		NSLog(@"点击了label--%@", x);
	}];
}

- (void)demo
{
	RACSignal *singal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		[subscriber sendNext:@"发送的数据"];
		//	一旦调用`sendCompleted`之后，后面的信号就不再发送了
		[subscriber sendCompleted];
		[subscriber sendNext:@"我还想发送数据"];
		return nil;
	}];
	[singal subscribeNext:^(id  _Nullable x) {
		NSLog(@"这里是接收到的数据:%@", x);
	}];
}

- (void)hotSignal
{
	RACSubject *subject = [RACSubject subject];
	[subject sendNext:@1];
	[[RACScheduler mainThreadScheduler] afterDelay:0.5 schedule:^{
		[subject sendNext:@2];
	}];
	
	[[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
		[subject sendNext:@3];
	}];
	
	[[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
		[subject subscribeNext:^(id  _Nullable x) {
			NSLog(@"subject1接收到了%@", x);
		}];
	}];
	
	[[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
		[subject subscribeNext:^(id  _Nullable x) {
			NSLog(@"subject2接收到了%@", x);
		}];
	}];
}

- (void)coldSingal
{
	RACSignal *singal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		[subscriber sendNext:@1];
		[[RACScheduler mainThreadScheduler] afterDelay:0.5 schedule:^{
			[subscriber sendNext:@2];
		}];
		[[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
			[subscriber sendNext:@3];
		}];
		return nil;
	}];
	
	[[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
		[singal subscribeNext:^(id  _Nullable x) {
			NSLog(@"singal1接收到了:%@", x);
		}];
	}];
	
	[[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
		[singal subscribeNext:^(id  _Nullable x) {
			NSLog(@"singal2接收到了:%@", x);
		}];
	}];
}

- (void)convertColdSingalToHotSingal
{
	RACMulticastConnection *connection = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
		[subscriber sendNext:@"1"];
		[[RACScheduler mainThreadScheduler] afterDelay:0.5 schedule:^{
			[subscriber sendNext:@"2"];
		}];
		
		[[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
			[subscriber sendNext:@"3"];
		}];
		return nil;
	}] publish];
	[connection connect];
	RACSignal *singal = connection.signal;
	[[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
		[singal subscribeNext:^(id  _Nullable x) {
			NSLog(@"singal1接收到了:%@", x);
		}];
	}];
	
	[[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
		[singal subscribeNext:^(id  _Nullable x) {
			NSLog(@"singal2接收到了:%@", x);
		}];
	}];
}

//- (TempView *)tempView
//{
//	if (!_tempView)
//	{
//		_tempView = [[NSBundle mainBundle] loadNibNamed:@"TempView" owner:nil options:nil].lastObject;
//		_tempView.frame = CGRectMake(50, 100, self.view.frame.size.width - 100, self.view.frame.size.height -200);
//		_tempView.backgroundColor = [UIColor blueColor];
//	}
//	return _tempView;
//}

- (TempViewModel *)tempViewModel
{
	if (!_tempViewModel)
	{
		_tempViewModel = [[TempViewModel alloc] init];
	}
	return _tempViewModel;
}

@end
