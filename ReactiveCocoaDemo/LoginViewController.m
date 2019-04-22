//
//  LoginViewController.m
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/18.
//  Copyright © 2019 张波. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (weak,   nonatomic) IBOutlet LoginView *loginView;
@property (strong, nonatomic) LoginViewModel *loginViewModel;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self bindViewModel];
}

- (void)bindViewModel
{
	self.loginView.loginViewModel = self.loginViewModel;
}

#pragma mark - Getter
- (LoginViewModel *)loginViewModel
{
	if (!_loginViewModel)
	{
		_loginViewModel = [[LoginViewModel alloc] init];
	}
	return _loginViewModel;
}

@end
