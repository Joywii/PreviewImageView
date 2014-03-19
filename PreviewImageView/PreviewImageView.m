//
//  PreviewPhotoView.m
//
//
//  Created by Joywii on 13-10-16.
//  Copyright (c) 2013年 Joywii. All rights reserved.
//

#import "PreviewImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface PreviewImageView ()<UIActionSheetDelegate>

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) NSValue *starRectValue;
@property (nonatomic,strong) NSValue *imageRectValue;

@end

@implementation PreviewImageView

+ (void)showPreviewImage:(UIImage *)image startImageFrame:(CGRect)startImageFrame inView:(UIView *)inView viewFrame:(CGRect)viewFrame
{
    PreviewImageView *preImageView = [[PreviewImageView alloc] initWithFrame:viewFrame withImage:image startFrame:startImageFrame];
    [inView addSubview:preImageView];
}
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image startFrame:(CGRect)startFrame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.opaque = YES;
        
        self.starRectValue =  [NSValue valueWithCGRect:startFrame];
        
        self.contentView = [[UIView alloc] initWithFrame:startFrame];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.userInteractionEnabled = YES;
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 3.0;
        [self addSubview:self.contentView];
        
        CGRect imageFrame = startFrame;
        imageFrame.origin.x = 0;
        imageFrame.origin.y = 0;
        self.imageRectValue = [NSValue valueWithCGRect:imageFrame];
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.photoImageView.image = image;
        self.photoImageView.backgroundColor = [UIColor clearColor];
        self.photoImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.photoImageView];
        
        [self addTapPressGestureRecognizer];
        [self addLongPressGestureRecognizer];
        
        [UIView beginAnimations:@"backgroundcolor" context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.backgroundColor = [UIColor blackColor];
        [UIView commitAnimations];
        
        [self startShowAnimation];
    }
    return self;
}
- (void)handleTapView:(UIGestureRecognizer *)gestureRecognizer
{
    [self startHideAnimation];
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.4];
}
- (void)hide
{
    [self removeFromSuperview];
}
- (void)startShowAnimation
{
    [UIView beginAnimations:@"scaleImageShow" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.photoImageView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    [UIView commitAnimations];
}
- (void)startHideAnimation
{
    [UIView beginAnimations:@"scaleImageHide" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.photoImageView.frame = [self.imageRectValue CGRectValue];
    self.contentView.frame = [self.starRectValue CGRectValue];
    self.backgroundColor = [UIColor clearColor];
    [UIView commitAnimations];
}
- (void)addTapPressGestureRecognizer
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    
    tapGR.cancelsTouchesInView = NO;
	tapGR.delaysTouchesBegan = NO;
	tapGR.delaysTouchesEnded = NO;
	tapGR.numberOfTapsRequired = 1;
	tapGR.numberOfTouchesRequired = 1;
    
    [tapGR addTarget:self action:@selector(handleTapView:)];
    [self addGestureRecognizer:tapGR];
}
- (void)addLongPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleLongPress:)];
    
    [longPressGR setMinimumPressDuration:0.4];
    [self addGestureRecognizer:longPressGR];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"保存到相册"
                                                   otherButtonTitles:nil];
        action.actionSheetStyle = UIActionSheetStyleDefault;
        action.tag = 123456;
        
        [action showInView:self];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 123456 && buttonIndex == 0)
    {
        if (self.photoImageView.image)
        {
            UIImageWriteToSavedPhotosAlbum(self.photoImageView.image,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
        }
        else
        {
            NSLog(@"image is nil");
        }
    }
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        NSLog(@"%@",error);
    }
    else
    {
        NSLog(@"save success!");
    }
}
@end
