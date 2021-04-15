//
//  PoporFloatConfig.h
//  PoporFloatBT
//
//  Created by popor on 2020/7/28.
//  Copyright © 2020 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PoporFloatBT.h"
#import <PoporAlertBubbleView/AlertBubbleView.h>

NS_ASSUME_NONNULL_BEGIN

#define PfeInit(tag, title)             [[PoporFloatEntity alloc] initTag:tag t##itle:title]
#define PfeClose(tag, title, autoClose) [[PoporFloatEntity alloc] initTag:tag t##itle:title close:autoClose]

@class PoporFloatEntity;
typedef void(^Block_PoporFloatView)(UIButton * bt);
typedef void(^Block_PoporFloatEntity)(PoporFloatEntity * pfEntity);

@interface PoporFloatEntity : NSObject

@property (nonatomic        ) NSInteger  tag;
@property (nonatomic, copy  ) NSString * title;
@property (nonatomic        ) BOOL       autoClose; //点击cell之后是否自动关闭
@property (nonatomic, strong) id         data;

- (instancetype)initTag:(NSInteger)tag title:(NSString *)title;

- (instancetype)initTag:(NSInteger)tag title:(NSString *)title close:(BOOL)autoClose;

@end

@interface PoporFloatTV : NSObject

// 不推荐修改的参数
@property (nonatomic, weak  ) PoporFloatBT    * pf;
@property (nonatomic, strong) AlertBubbleView * tvContentView;
@property (nonatomic, strong) UITableView     * tv;
@property (nonatomic, strong) UIColor         * tvBgColor;
@property (nonatomic, strong) UITapGestureRecognizer * showTapGr;

@property (nonatomic, strong) NSMutableDictionary * btCellDic;
@property (nonatomic, copy  ) NSArray<PoporFloatEntity *> * currentCellArray;

// 可以修改的参数
@property (nonatomic        ) CGFloat tvWidth;
@property (nonatomic        ) CGFloat tvCellHeight;

@property (nonatomic, copy  ) Block_PoporFloatView   btSelectBlock;
@property (nonatomic, copy  ) Block_PoporFloatEntity tvSelectBlock;


+ (instancetype)share;

- (UIButton *)addBtSize:(CGSize)size cellArray:(NSArray<PoporFloatEntity *> * _Nullable)cellArray;

// 双指双击打开事件.
- (void)addDefaultShowGR;

- (void)showHiddenFloatView;

@end

NS_ASSUME_NONNULL_END
