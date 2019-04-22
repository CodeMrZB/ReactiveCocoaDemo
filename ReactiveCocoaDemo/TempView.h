//
//  TempView.h
//  ReactiveCocoaDemo
//
//  Created by 张波 on 2019/4/13.
//  Copyright © 2019 张波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE

@interface TempView : UIView<XXNibBridge>

@property (strong, nonatomic) RACSubject *itemClickSubject;

@end

NS_ASSUME_NONNULL_END
