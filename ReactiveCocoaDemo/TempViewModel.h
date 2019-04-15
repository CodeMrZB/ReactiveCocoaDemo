//
//  TempViewModel.h
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/14.
//  Copyright © 2019 张波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TempViewModel : NSObject

@property (strong, nonatomic) RACCommand *loginCommand;

@end

NS_ASSUME_NONNULL_END
