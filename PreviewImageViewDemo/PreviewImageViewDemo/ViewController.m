//
//  ViewController.m
//  PreviewImageViewDemo
//
//  Created by Joywii on 14-3-19.
//  Copyright (c) 2014年 Joywii. All rights reserved.
//

#import "ViewController.h"
#import "PreviewImageView.h"


@interface ViewController ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(125, 200, 70, 100)];
    self.imageView.image = [UIImage imageNamed:@"test"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 3.0;
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    tapGR.cancelsTouchesInView = YES;
	tapGR.delaysTouchesBegan = NO;
	tapGR.delaysTouchesEnded = NO;
	tapGR.numberOfTapsRequired = 1;
	tapGR.numberOfTouchesRequired = 1;
    [tapGR addTarget:self action:@selector(handleTapView:)];
    [self.imageView addGestureRecognizer:tapGR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleTapView:(UIGestureRecognizer *)gestureRecognizer
{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [self.imageView convertRect:self.imageView.bounds toView:windows];
    [PreviewImageView showPreviewImage:self.imageView.image startImageFrame:startRect inView:windows viewFrame:self.view.bounds];
}

@end
