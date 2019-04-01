//
//  GDGuidePageHUD.h
//  GoldenCloud
//
//  Created by 黄彬彬 on 2019/3/6.
//  Copyright © 2019 黄彬彬. All rights reserved.
//  引导页 图片（含gif） | 视频

#import <UIKit/UIKit.h>

#define GDGuideTag @"GDGuideTag"//这个要根据版本号去判断

NS_ASSUME_NONNULL_BEGIN

@interface GDGuidePageHUD : UIView


/**
 是否支持滑动进入APP(默认为NO-不支持滑动进入APP | 只有在buttonIsHidden为YES-隐藏状态下可用; buttonIsHidden为NO-显示状态下直接点击按钮进入)
 视频引导页同样不支持滑动进入APP
 */
@property (nonatomic, assign) BOOL slideInto;


/**
 图片引导页 | 可自动识别动态图片和静态图片

 @param frame          位置大小
 @param imageNameArray 引导页图片数组(NSString)
 @param isHidden       开始体验按钮是否隐藏(YES:隐藏-引导页完成自动进入APP首页; NO:不隐藏-引导页完成点击开始体验按钮进入APP主页)
 @return               操作对象
 */
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden;


/**
 视频引导页

 @param frame    位置大小
 @param videoURL 引导页视频地址
 @return         操作对象
 */
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL;

@end

NS_ASSUME_NONNULL_END
