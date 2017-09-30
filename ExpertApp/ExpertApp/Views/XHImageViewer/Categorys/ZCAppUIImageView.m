//
//  ZCAppUIImageView.m
//  ExpertKitLimit
//
//  Created by zhangxy on 15/11/21.
//  Copyright © 2015年 zhichi. All rights reserved.
//

#import "ZCAppUIImageView.h"

#import "ZZImageTools.h"

#import <objc/runtime.h>

#import "XHCacheManager.h"

const char* const kXHURLPropertyKey    = "XHURLDownloadURLPropertyKey";
const char* const kXHLoadingStateKey   = "XHURLDownloadLoadingStateKey";
const char* const kXHLoadingViewKey    = "XHURLDownloadLoadingViewKey";

const char* const kXHActivityIndicatorViewKey    = "XHActivityIndicatorViewKey";

#define kXHActivityIndicatorViewSize 35

@implementation ZCAppUIImageView

+ (id)imageViewWithURL:(NSURL *)url autoLoading:(BOOL)autoLoading {
    ZCAppUIImageView *view = [self new];
    view.url = url;
    if(autoLoading) {
        [view load];
    }
    return view;
}

+ (id)indicatorImageView {
    ZCAppUIImageView *view = [self new];
    [view setDefaultLoadingView];
    
    return view;
}

+ (id)indicatorImageViewWithURL:(NSURL *)url autoLoading:(BOOL)autoLoading {
    ZCAppUIImageView *view = [self imageViewWithURL:url autoLoading:autoLoading];
    [view setDefaultLoadingView];
    
    return view;
}

#pragma mark- Properties

- (dispatch_queue_t)cachingQueue {
    static dispatch_queue_t cachingQeueu;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cachingQeueu = dispatch_queue_create("caching image and data", NULL);
    });
    return cachingQeueu;
}

- (void)setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView {
    objc_setAssociatedObject(self, kXHActivityIndicatorViewKey , activityIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)activityIndicatorView {
    return objc_getAssociatedObject(self, kXHActivityIndicatorViewKey );
}

- (NSURL*)url {
    return objc_getAssociatedObject(self, kXHURLPropertyKey );
}

- (void)setUrl:(NSURL *)url {
    [self setUrl:url autoLoading:NO];
}

- (void)setUrl:(NSURL *)url autoLoading:(BOOL)autoLoading {
    if(![url isEqual:self.url]) {
        objc_setAssociatedObject(self, kXHURLPropertyKey , url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (url) {
            self.loadingState = UIImageViewURLDownloadStateWaitingForLoad;
        }
        else {
            self.loadingState = UIImageViewURLDownloadStateUnknown;
        }
    }
    
    if(autoLoading) {
        [self load];
    }
}

- (void)loadWithURL:(NSURL *)url {
    [self loadWithURL:url placeholer:nil];
}

- (void)loadWithURL:(NSURL *)url placeholer:(UIImage *)placeholerImage {
    [self loadWithURL:url placeholer:placeholerImage showActivityIndicatorView:NO];
}

- (void)loadWithURL:(NSURL *)url placeholer:(UIImage *)placeholerImage showActivityIndicatorView:(BOOL)show {
    UIImage *cacheImage = [XHCacheManager imageWithURL:url storeMemoryCache:YES];
    if(cacheImage){
        [self _setupPlaecholerImage:cacheImage showActivityIndicatorView:NO];
    }else{
        [self _setupPlaecholerImage:placeholerImage showActivityIndicatorView:show];
        
        [self setUrl:url autoLoading:YES];
    }
}

- (void)loadWithURL:(NSURL *)url placeholer:(UIImage *)placeholerImage showActivityIndicatorView:(BOOL)show completionBlock:(void(^)(UIImage *image, NSURL *url, NSError *error))handler {
    [self _setupPlaecholerImage:placeholerImage showActivityIndicatorView:show];
    [self setUrl:url autoLoading:NO];
    [self loadWithCompletionBlock:handler];
}

- (void)_setupPlaecholerImage:(UIImage *)placeholerImage showActivityIndicatorView:(BOOL)show {
    if (placeholerImage)
        [self setImage:placeholerImage];
    if (show) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.frame = CGRectMake(0, 0, kXHActivityIndicatorViewSize, kXHActivityIndicatorViewSize);
        activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [activityIndicatorView startAnimating];
        [self addSubview:activityIndicatorView];
        [self setActivityIndicatorView:activityIndicatorView];
    }
}

- (UIImageViewURLDownloadState)loadingState {
    return (NSUInteger)([objc_getAssociatedObject(self, kXHLoadingStateKey ) integerValue]);
}

- (void)setLoadingState:(UIImageViewURLDownloadState)loadingState {
    objc_setAssociatedObject(self, kXHLoadingStateKey , @(loadingState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)loadingView {
    return objc_getAssociatedObject(self, kXHLoadingViewKey );
}

- (void)setLoadingView:(UIView *)loadingView {
    [self.loadingView removeFromSuperview];
    
    objc_setAssociatedObject(self, kXHLoadingViewKey , loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    loadingView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    loadingView.alpha  = 0;
    [self addSubview:loadingView];
}

- (void)setDefaultLoadingView {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = self.frame;
    indicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    indicator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.loadingView = indicator;
}

#pragma mark- Loading view

- (void)showLoadingView {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadingView.alpha = 1;
        if([self.loadingView respondsToSelector:@selector(startAnimating)]) {
            [self.loadingView performSelector:@selector(startAnimating)];
        }
    });
}

- (void)hideLoadingView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActivityIndicatorView *activityIndicatorView = [self activityIndicatorView];
        if (activityIndicatorView) {
            [activityIndicatorView stopAnimating];
            [activityIndicatorView removeFromSuperview];
        }
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.loadingView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             if([self.loadingView respondsToSelector:@selector(stopAnimating)]) {
                                 [self.loadingView performSelector:@selector(stopAnimating)];
                             }
                         }
         ];
    });
}

#pragma mark- Image downloading

+ (NSOperationQueue *)downloadQueue {
    static NSOperationQueue *_sharedQueue = nil;
    
    if(_sharedQueue == nil) {
        _sharedQueue = [NSOperationQueue new];
        [_sharedQueue setMaxConcurrentOperationCount:3];
    }
    
    return _sharedQueue;
}

+ (void)dataWithContentsOfURL:(NSURL *)url completionBlock:(void (^)(NSURL *, NSData *, NSError *))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:5.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[self downloadQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if(completion) {
                                   completion(url, data, connectionError);
                               }
                           }
     ];
}

- (void)load {
    [self loadWithCompletionBlock:nil];
}

- (void)loadWithCompletionBlock:(void(^)(UIImage *image, NSURL *url, NSError *error))handler {
    self.loadingState = UIImageViewURLDownloadStateNowLoading;
    
    [self showLoadingView];
    
    __block typeof(self) weakSelf = self;
    dispatch_async(self.cachingQueue, ^{
        UIImage *cacheImage = [XHCacheManager imageWithURL:weakSelf.url storeMemoryCache:YES];
        if (cacheImage) {
            [self setImage:cacheImage forURL:weakSelf.url];
            if (handler)
                handler(cacheImage, weakSelf.url, nil);
        } else {
            // It could be more better by replacing with a method that has delegates like a progress.
            [ZCAppUIImageView dataWithContentsOfURL:weakSelf.url
                               completionBlock:^(NSURL *url, NSData *data, NSError *error) {
                                   UIImage *image = [weakSelf didFinishDownloadWithData:data forURL:url error:error];
                                   
                                   if(handler) {
                                       handler(image, url, error);
                                   }
                               }
             ];
        }
    });
}

- (void)cachingImageData:(NSData *)imageData url:(NSURL *)url {
    dispatch_async(self.cachingQueue, ^{
        if (imageData) {
            [XHCacheManager storeData:imageData forURL:url storeMemoryCache:NO];
            UIImage *image = [ZZImageTools zc_imageWithData:imageData];//[UIImage imageWithData:imageData];
            if (image)
                [XHCacheManager storeMemoryCacheWithImage:image forURL:url];
        }
    });
}

- (UIImage *)didFinishDownloadWithData:(NSData *)data forURL:(NSURL *)url error:(NSError *)error {
    if (data) {
        [self cachingImageData:data url:url];
    }
    UIImage *image =  [ZZImageTools zc_imageWithData:data];// [UIImage imageWithData:data];
    if([url isEqual:self.url]) {
        if(error) {
            self.loadingState = UIImageViewURLDownloadStateFailed;
        } else {
            [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            self.loadingState = UIImageViewURLDownloadStateLoaded;
        }
        [self hideLoadingView];
    }
    return image;
}


- (void)setImage:(UIImage *)image forURL:(NSURL *)url {
    if([url isEqual:self.url]) {
        [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        self.loadingState = UIImageViewURLDownloadStateLoaded;
        [self hideLoadingView];
    }
}
@end
