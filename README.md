PreviewImageView
================

图片从小图到全屏大图的预览和长按保存到本地相册（类似很多社交类应用图片预览的实现）

###如何使用
```
UIWindow *windows = [UIApplication sharedApplication].keyWindow;
CGRect startRect = [self.imageView convertRect:self.imageView.bounds toView:windows];
[PreviewImageView showPreviewImage:self.imageView.image startImageFrame:startRect inView:windows viewFrame:self.view.bounds];)
```
