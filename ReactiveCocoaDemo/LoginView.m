//
//  LoginView.m
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/18.
//  Copyright © 2019 张波. All rights reserved.
//

#import "LoginView.h"
#import "LoginViewModel.h"

@interface LoginView ()

@property (weak,   nonatomic) IBOutlet UIImageView *headImv;
@property (weak,   nonatomic) IBOutlet UITextField *userNameTF;
@property (weak,   nonatomic) IBOutlet UITextField *pwdTF;
@property (weak,   nonatomic) IBOutlet UILabel *statusLabel;
@property (weak,   nonatomic) IBOutlet UIButton *loginItem;

@end

@implementation LoginView

#pragma mark - Setter
- (void)setLoginViewModel:(LoginViewModel *)loginViewModel
{
	_loginViewModel = loginViewModel;
	RAC(loginViewModel, userName) = self.userNameTF.rac_textSignal;
	RAC(loginViewModel, pwd) = self.pwdTF.rac_textSignal;
	RAC(self.loginItem, enabled) = loginViewModel.loginEnableSignal;
	RAC(self.statusLabel, text) = loginViewModel.statusSubject;
	[RACObserve(loginViewModel, iconUrl) subscribeNext:^(id  _Nullable x) {
		NSLog(@"x:%@", x);
		self.headImv.image = [UIImage imageNamed:x];
	}];
	@weakify(self);
	//	登录按钮能否点击颜色变化
	[loginViewModel.loginEnableSignal subscribeNext:^(NSNumber *x) {
		@strongify(self);
		UIColor *backgroundColor = x.boolValue ? [UIColor redColor] : [UIColor grayColor];
		UIColor *titleColor = x.boolValue ? [UIColor whiteColor] : [UIColor cyanColor];
		self.loginItem.backgroundColor = backgroundColor;
		[self.loginItem setTitleColor:titleColor forState:UIControlStateNormal];
	}];
	//	监听按钮点击事件
	[[self.loginItem rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
		@strongify(self);
		NSLog(@"点击了按钮");
		[self endEditing:YES];
		[loginViewModel.loginCommand execute:@"执行登录"];
	}];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[self endEditing:YES];
}

@end
