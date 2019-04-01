//
//  GDGuidePageHUD.m
//  GoldenCloud
//
//  Created by 黄彬彬 on 2019/3/6.
//  Copyright © 2019 黄彬彬. All rights reserved.
//

#import "GDGuidePageHUD.h"
#import "GDGifImageOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#define GDGuideHidden_TIME   3.0
#define GDGuideScreenW   [UIScreen mainScreen].bounds.size.width
#define GDGuideScreenH   [UIScreen mainScreen].bounds.size.height

@interface GDGuidePageHUD ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray                 *imageArray;
@property (nonatomic, strong) UIScrollView            *guidePageView;
@property (nonatomic, strong) UIButton                *skipButton;
@property (nonatomic, strong) UIButton                *movieStartButton;

@property (nonatomic, strong) UIPageControl           *imagePageControl;
@property (nonatomic, assign) NSInteger               slideIntoNumber;
@property (nonatomic, strong) MPMoviePlayerController *playerController;

@end


@implementation GDGuidePageHUD

- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden {
    if ([super initWithFrame:frame]) {
        self.slideInto = NO;
        if (isHidden == YES) {
            self.imageArray = imageNameArray;
        }
        
        // 设置引导视图的scrollview
        [self addSubview:self.guidePageView];
        
        // 设置引导页上的跳过按钮
        [self addSubview:self.skipButton];
        
        // 添加在引导视图上的多张引导图片
        for (int i = 0; i < imageNameArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(GDGuideScreenW*i, 0, GDGuideScreenW, GDGuideScreenH)];
            if ([[GDGifImageOperation contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]]] isEqualToString:@"gif"]) {
                NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]];
                imageView = (UIImageView *)[[GDGifImageOperation alloc] initWithFrame:imageView.frame gifImageData:localData];
                [_guidePageView addSubview:imageView];
            } else {
                imageView.image = [UIImage imageNamed:imageNameArray[i]];
                [_guidePageView addSubview:imageView];
            }
            
            // 设置在最后一张图片上显示进入体验按钮
            if (i == imageNameArray.count-1 && isHidden == NO) {
                [imageView setUserInteractionEnabled:YES];
                UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(GDGuideScreenW*0.3, GDGuideScreenH*0.8, GDGuideScreenW*0.4, GDGuideScreenH*0.08)];
                [startButton setTitle:@"开始体验" forState:UIControlStateNormal];
                [startButton setTitleColor:[UIColor colorWithRed:164/255.0 green:201/255.0 blue:67/255.0 alpha:1.0] forState:UIControlStateNormal];
                [startButton.titleLabel setFont:[UIFont systemFontOfSize:21]];
                [startButton setBackgroundImage:[UIImage imageNamed:@"GDGuideImage.bundle/guideImage_button_backgound"] forState:UIControlStateNormal];
                [startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:startButton];
            }
        }
        
        // 设置引导页上的页面控制器
        [self addSubview:self.imagePageControl];
    }
    return self;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    int page = scrollview.contentOffset.x / scrollview.frame.size.width;
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == NO) {
        [self buttonClick:nil];
    }
    if (self.imageArray && page < self.imageArray.count-1 && self.slideInto == YES) {
        self.slideIntoNumber = 1;
    }
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == YES) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:nil action:nil];
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
            self.slideIntoNumber++;
            if (self.slideIntoNumber == 3) {
                [self buttonClick:nil];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 四舍五入,保证pageControl状态跟随手指滑动及时刷新
    [self.imagePageControl setCurrentPage:(int)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5f)];
}

#pragma mark - EventClick
- (void)buttonClick:(UIButton *)button {
    [UIView animateWithDuration:GDGuideHidden_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(GDGuideHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
        });
    }];
}

- (void)removeGuidePageHUD {
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL {
    if ([super initWithFrame:frame]) {
        self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        [self.playerController.view setFrame:frame];
        [self.playerController.view setAlpha:1.0];
        [self.playerController setControlStyle:MPMovieControlStyleNone];
        [self.playerController setRepeatMode:MPMovieRepeatModeOne];
        [self.playerController setShouldAutoplay:YES];
        [self.playerController prepareToPlay];
        [self addSubview:self.playerController.view];
        
        // 视频引导页进入按钮
        UIButton *movieStartButton = [[UIButton alloc] initWithFrame:CGRectMake(20, GDGuideScreenH-30-40, GDGuideScreenW-40, 40)];
        [movieStartButton.layer setBorderWidth:1.0];
        [movieStartButton.layer setCornerRadius:20.0];
        [movieStartButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [movieStartButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [movieStartButton setAlpha:0.0];
        [self.playerController.view addSubview:movieStartButton];
        [movieStartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:GDGuideHidden_TIME animations:^{
            [movieStartButton setAlpha:1.0];
        }];
    }
    return self;
}


#pragma mark - lazy
- (UIScrollView *)guidePageView {
    if (_guidePageView == nil) {
        _guidePageView = [[UIScrollView alloc] initWithFrame:self.frame];
        [_guidePageView setBackgroundColor:[UIColor lightGrayColor]];
        [_guidePageView setContentSize:CGSizeMake(GDGuideScreenW*self.imageArray.count, GDGuideScreenH)];
        [_guidePageView setBounces:NO];
        [_guidePageView setPagingEnabled:YES];
        [_guidePageView setShowsHorizontalScrollIndicator:NO];
        [_guidePageView setDelegate:self];
    }
    return _guidePageView;
}


- (UIButton *)skipButton {
    if (_skipButton == nil) {
        _skipButton = [[UIButton alloc]initWithFrame:CGRectMake(GDGuideScreenW*0.8, GDGuideScreenW*0.1, 50, 25)];
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_skipButton setBackgroundColor:[UIColor grayColor]];
        // [skipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // [skipButton.layer setCornerRadius:5.0];
        [_skipButton.layer setCornerRadius:(_skipButton.frame.size.height * 0.5)];
        [_skipButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

- (UIPageControl *)imagePageControl {
    if (_imagePageControl == nil) {
        _imagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(GDGuideScreenW*0.0, GDGuideScreenH*0.9, GDGuideScreenW*1.0, GDGuideScreenH*0.1)];
        _imagePageControl.currentPage = 0;
        _imagePageControl.numberOfPages = _imageArray.count;
        _imagePageControl.pageIndicatorTintColor = [UIColor grayColor];
        _imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _imagePageControl;
}

@end
