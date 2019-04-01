//
//  ViewController.m
//  Example
//
//  Created by 黄彬彬 on 2019/4/1.
//  Copyright © 2019 黄彬彬. All rights reserved.
//

#import "ViewController.h"
#import "GDGuidePageHUD.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GDGuidePageHUD *hud = [[GDGuidePageHUD alloc] initWithFrame:self.view.frame imageNameArray:@[@"引导页1.jpg", @"引导页2.jpg", @"引导页3.jpg", @"引导页4.jpg"] buttonIsHidden:YES];
    [self.view addSubview:hud];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
