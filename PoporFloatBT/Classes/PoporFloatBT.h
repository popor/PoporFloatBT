//
//  PoporFloatBT.h
//  PoporFloatBT
//
//  Created by popor on 2020/7/28.
//  Copyright © 2020 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoporFloatBT : NSObject

@property (nonatomic, weak  ) UIWindow       * window;
@property (nonatomic, strong) NSMutableArray * btArray;

@property (nonatomic        ) CGFloat    btHideWidth;
@property (nonatomic        ) CGFloat    btMovingAlpha;
@property (nonatomic        ) CGFloat    btStayAlpha;

@property (nonatomic        ) NSInteger  currentBtTag;

@property (nonatomic        ) BOOL autoFixIphoneXFrame; // 默认为YES, 防止ballBT位于在屏幕上方出现, iPhoneX机型可能无法点击到BT.

+ (instancetype)share;

- (UIButton *)addFloatBtSize:(CGSize)size;

- (UIButton *)currentBT;

+ (BOOL)isIphoneXScreen;

+ (CGFloat)statusBarHeight;

@end

NS_ASSUME_NONNULL_END
