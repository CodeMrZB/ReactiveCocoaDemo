//
//  LoginView.h
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/18.
//  Copyright © 2019 张波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewModel;

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE

@interface LoginView : UIView<XXNibBridge>

@property (strong, nonatomic) LoginViewModel *loginViewModel;

@end

NS_ASSUME_NONNULL_END
