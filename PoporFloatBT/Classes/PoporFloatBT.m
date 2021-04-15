//
//  PoporFloatBT.m
//  PoporFloatBT
//
//  Created by popor on 2020/7/28.
//  Copyright © 2020 popor. All rights reserved.
//

#import "PoporFloatBT.h"

@interface PoporFloatBT () <UIGestureRecognizerDelegate>

@property (nonatomic, getter=isIphoneX) BOOL iphoneX;
@property (nonatomic        ) CGFloat screenWidth;
@property (nonatomic        ) CGFloat screenHeight;

@end

@implementation PoporFloatBT

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporFloatBT * instance;
    dispatch_once(&once, ^{
        instance = [self new];
       
        
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _iphoneX             = [[self class] isIphoneXScreen];
        _btMovingAlpha       = 1.0;
        _btStayAlpha         = 0.5;
        _autoFixIphoneXFrame = YES;
        _screenWidth         = [[UIScreen mainScreen] bounds].size.width;
        _screenHeight        = [[UIScreen mainScreen] bounds].size.height;
        _btHideWidth         = 10;
        _btArray             = [NSMutableArray new];
    }
    return self;
}

- (UIButton *)addFloatBtSize:(CGSize)size {
    self.window = [[UIApplication sharedApplication] keyWindow];
    
    UIButton * bt = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(0, 0, size.width, size.height);
        
        [button setBackgroundColor:[UIColor brownColor]];
        button.layer.cornerRadius = button.frame.size.width/2;
        button.clipsToBounds      = YES;
        
        [self.window addSubview:button];
        
        button;
    });
    bt.tag = self.btArray.count;
    
    [self.btArray addObject:bt];
    
    {
        NSString * pointString = [self getPositionPointTag:bt.tag];
        if (pointString) {
            bt.center = CGPointFromString(pointString);
        }else{
            bt.center = CGPointMake(bt.frame.size.width/2, 180);
        }
        
        bt.alpha  = self.btStayAlpha;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
        [bt addGestureRecognizer:pan];
    }
    
    return bt;
}

#pragma mark - Action
// 球移动轨迹
- (void)panGR:(UIPanGestureRecognizer *)gr {
    CGPoint panPoint = [gr locationInView:[[UIApplication sharedApplication] keyWindow]];
    //NSLog(@"panPoint: %f-%f", panPoint.x, panPoint.y);
    if (gr.state == UIGestureRecognizerStateBegan) {
        self.currentBtTag = gr.view.tag;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resignActive) object:nil];
        [self becomeActive];
    } else if (gr.state == UIGestureRecognizerStateChanged) {
        [self changeSBallViewFrameWithPoint:panPoint];
    } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled || gr.state == UIGestureRecognizerStateFailed) {
        [self resignActive];
    }
}

- (UIButton *)currentBT {
    return self.btArray[self.currentBtTag];
}

- (void)becomeActive {
    self.currentBT.alpha = self.btMovingAlpha;
}

- (void)resignActive {
    UIView * view = self.currentBT;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.alpha  = self.btStayAlpha;
        view.center = [self fixIphoneXCenter];
    } completion:^(BOOL finished) {
        [self savePositionPoint:NSStringFromCGPoint(view.center) tag:view.tag];
        //NSLog(@"__frame:%@ center:%@", NSStringFromCGRect(self.ballBT.frame), NSStringFromCGPoint(self.ballBT.center));
    }];
}

- (void)changeSBallViewFrameWithPoint:(CGPoint)point {
    UIView * view = self.currentBT;
    
    view.center = CGPointMake(point.x, point.y);
}

// 获取到对应的center
- (CGPoint)fixIphoneXCenter {
    UIView * view    = self.currentBT;
    
    CGFloat x         = view.center.x;
    CGFloat y         = view.center.y;
    CGFloat x1        = self.screenWidth / 2.0;
    CGFloat y1        = self.screenHeight / 2.0;
    CGFloat Width     = view.frame.size.width;
    CGFloat Height    = view.frame.size.height;
    
    if (self.isIphoneX && self.autoFixIphoneXFrame) {
        if (y < 60) {
            y = 60;
            if (x <= x1) {
                x = Width / 2.0 - self.btHideWidth;
            } else {
                x = self.screenWidth - Width / 2.0 + self.btHideWidth;;
            }
        }
    }
    
    CGFloat distanceX = x1 > x ? x : self.screenWidth - x;
    CGFloat distanceY = y1 > y ? y : self.screenHeight - y;
    CGPoint endPoint  = CGPointZero;
    
    if (distanceX <= distanceY) {
        // animation to left or right
        endPoint.y = y;
        if (x1 < x) {
            // to right
            endPoint.x = self.screenWidth - Width / 2.0 + self.btHideWidth;
        } else {
            // to left
            endPoint.x = Width / 2.0 - self.btHideWidth;
        }
    } else {
        // animation to top or bottom
        endPoint.x = x;
        if (y1 < y) {
            // to bottom
            endPoint.y = self.screenHeight - Height / 2.0 + self.btHideWidth;
        } else {
            // to top
            endPoint.y = Height / 2.0 - self.btHideWidth;
        }
    }
    
    return endPoint;
}

#pragma mark - 记录按钮位置
- (void)savePositionPoint:(NSString *)point tag:(NSInteger)tag {
    [[NSUserDefaults standardUserDefaults] setObject:point forKey:[self positionPlistSaveKeyTag:tag]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getPositionPointTag:(NSInteger)tag {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:[self positionPlistSaveKeyTag:tag]];
    return info;
}

- (NSString *)positionPlistSaveKeyTag:(NSInteger)tag {
    NSString * saveKey = [NSString stringWithFormat:@"%@_position_%li", NSStringFromClass([self class]), (long)tag];
    return saveKey;
}

#pragma mark - tool
+ (BOOL)isIphoneXScreen {
    if ([self statusBarHeight] >  20) {
        return YES;
    } else {
        return NO;
    }
}

+ (CGFloat)statusBarHeight {
    static CGFloat statusBarHeight;
    if (statusBarHeight == 0) {
        if (@available(iOS 13.0, *)) {
            statusBarHeight = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
        } else {
            statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
    }
    
    return statusBarHeight;
}

@end
