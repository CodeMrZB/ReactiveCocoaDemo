//
//  LoginViewModel.h
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/19.
//  Copyright © 2019 张波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : NSObject

@property (copy,   nonatomic) NSString *iconUrl;
@property (copy,   nonatomic) NSString *userName;
@property (copy,   nonatomic) NSString *pwd;
@property (strong, nonatomic) RACSignal *loginEnableSignal;
@property (strong, nonatomic) RACCommand *loginCommand;
@property (strong, nonatomic) RACSubject *statusSubject;
@property (assign, nonatomic) BOOL isLogining;

@end

NS_ASSUME_NONNULL_END
