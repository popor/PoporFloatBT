//
//  PoporFloatConfig.m
//  PoporFloatBT
//
//  Created by popor on 2020/7/28.
//  Copyright © 2020 popor. All rights reserved.
//

#import "PoporFloatTV.h"

@implementation PoporFloatEntity

- (instancetype)initTag:(NSInteger)tag title:(NSString *)title {
    self = [super init];
    if (self) {
        _tag       = tag;
        _title     = title;
        _autoClose = YES;
    }
    return self;
}

- (instancetype)initTag:(NSInteger)tag title:(NSString *)title close:(BOOL)autoClose {
    self = [super init];
    if (self) {
        _tag       = tag;
        _title     = title;
        _autoClose = autoClose;
    }
    return self;
}

@end

@interface PoporFloatTV () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PoporFloatTV

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporFloatTV * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
        instance.tvCellHeight = 42;
        instance.tvBgColor    = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        instance.tvWidth      = 140;
        instance.btCellDic    = [NSMutableDictionary new];
    });
    return instance;
}

- (UIButton *)addBtSize:(CGSize)size cellArray:(NSArray<PoporFloatEntity *> * _Nullable)cellArray {
    UIButton * bt = [[PoporFloatBT share] addFloatBtSize:size];
    if (cellArray) {
        [self.btCellDic setObject:cellArray forKey:[NSString stringWithFormat:@"%li", (long)bt.tag]];
    }
    
    [bt addTarget:self action:@selector(showFuncSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    return bt;
}

- (void)addDefaultShowGR {
    if (!self.showTapGr) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHiddenFloatView)];
        tap.numberOfTouchesRequired = 2;
        tap.numberOfTapsRequired    = 2;
        self.showTapGr              = tap;
        
        PoporFloatBT * pfView = [PoporFloatBT share];
        [pfView.window addGestureRecognizer:tap];
    }
}

- (void)showHiddenFloatView {
    UIButton * bt = [self.pf currentBT];
    BOOL hidden = bt.hidden;
    
    for (UIButton * bt in self.pf.btArray) {
        bt.hidden = !hidden;
    }
}

- (void)showFuncSelector:(UIButton *)bt {
    PoporFloatBT * pf = [PoporFloatBT share];
    self.pf = pf;
    
    self.currentCellArray = self.btCellDic[[NSString stringWithFormat:@"%li", (long)bt.tag]];
    if (self.currentCellArray.count != 0) {
        self.tv = [self addAlertBubbleTV];
        CGRect fromRect = bt.frame;
        fromRect.origin.y -= 0;
        
        NSDictionary * dic = @{
            @"direction"                :@(AlertBubbleViewDirectionLeft),
            @"directionSortArray"       :@[@(AlertBubbleViewDirectionLeft), @(AlertBubbleViewDirectionRight), @(AlertBubbleViewDirectionTop), @(AlertBubbleViewDirectionBottom)],
            @"baseView"                 :self.pf.window,
            @"borderLineColor"          :[UIColor whiteColor],
            @"borderLineWidth"          :@(1),
            @"corner"                   :@(self.tv.layer.cornerRadius),
            @"trangleHeight"            :@(8),
            @"trangleWidth"             :@(8),
            
            @"customInset"              :[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake([PoporFloatBT statusBarHeight], 20, 20, 7)],
            @"borderInset"              :[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)],
            
            @"bubbleBgColor"            :self.tvBgColor,
            @"bgColor"                  :[UIColor clearColor],
            @"showBgColorAnimationTime" :@(0.1),
            @"showAroundRect"           :@(NO),
            @"showLogInfo"              :@(NO),
        };
        
        self.tvContentView = [[AlertBubbleView alloc] initWithDic:dic];
        
        [self.tvContentView showCustomView:self.tv around:fromRect close:nil];
    }
    
    if (self.btSelectBlock) {
        self.btSelectBlock(bt);
    }
}

- (UITableView *)addAlertBubbleTV {
    UITableView * oneTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.tvWidth, self.tvCellHeight*self.currentCellArray.count) style:UITableViewStylePlain];
    
    oneTV.backgroundColor = [UIColor clearColor];
    oneTV.separatorColor  = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
    oneTV.separatorInset  = UIEdgeInsetsMake(0, 8, 0, 8);
    
    oneTV.delegate        = self;
    oneTV.dataSource      = self;
    
    oneTV.allowsMultipleSelectionDuringEditing = YES;
    oneTV.directionalLockEnabled = YES;
    
    oneTV.estimatedRowHeight           = 0;
    oneTV.estimatedSectionHeaderHeight = 0;
    oneTV.estimatedSectionFooterHeight = 0;
    
    oneTV.layer.cornerRadius = 10;
    oneTV.clipsToBounds      = YES;
    oneTV.scrollEnabled      = NO;
    
    return oneTV;
}

#pragma mark - TV_Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentCellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tvCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"CellID_alert";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        cell.textLabel.font      = [UIFont systemFontOfSize:15];
        cell.backgroundColor     = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.tintColor           = [UIColor whiteColor];
    }
    
    PoporFloatEntity * cie = self.currentCellArray[indexPath.row];
    cell.textLabel.text    = cie.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PoporFloatEntity * cie = self.currentCellArray[indexPath.row];
    if (cie.autoClose) {
        [self.tvContentView closeEvent];
    }
    
    if (self.tvSelectBlock) {
        self.tvSelectBlock(cie);
    }
}

@end
