//
//  DTLazyImageView.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 5/20/11.
//  Copyright 2011 Drobnik.com. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "DTLazyImageView.h"
#import "DTCompatibility.h"

#import <DTFoundation/DTLog.h>

static NSCache *_imageCache  = nil;
NSString * const DTLazyImageViewWillStartDownloadNotification = @"DTLazyImageViewWillStartDownloadNotification";
NSString * const DTLazyImageViewDidFinishDownloadNotification = @"DTLazyImageViewDidFinishDownloadNotification";

@interface DTLazyImageView ()
#if DTCORETEXT_USES_NSURLSESSION
<NSURLSessionDataDelegate>
#else
<NSURLConnectionDelegate>
#endif
@property (nonatomic, strong) NSMutableArray *arrDataTasks;
//@property (nonatomic, strong) NSMutableArray *arrSessions;
@property (nonatomic, strong) NSMutableDictionary *receivedDataInfo;

- (void)_notifyDelegateWithImageUrl:(NSURL *)url;

@end

@implementation DTLazyImageView
{
	NSURL *_url __attribute((deprecated(("use _imageUrlsInfo insteads"))));
//    NSArray *_imageUrls;
	
    NSMutableURLRequest *_urlRequest __attribute((deprecated(("use _arrUrlRequests insteads"))));
//    NSMutableArray *_arrUrlRequests;
	
#if DTCORETEXT_USES_NSURLSESSION
    
    
	NSURLSessionDataTask *_dataTask __attribute((deprecated(("use _arrDataTasks insteads"))));
	NSURLSession *_session;
#else
	NSURLConnection *_connection;
#endif
    
    
	NSMutableData *_receivedData __attribute((deprecated(("use _arrReceivedData insteads"))));

    
	/* For progressive download */
	CGImageSourceRef _imageSource;
	CGFloat _fullHeight;
	CGFloat _fullWidth;
	NSUInteger _expectedSize;
	
	BOOL shouldShowProgressiveDownload;
	
	DT_WEAK_VARIABLE id<DTLazyImageViewDelegate> _delegate;
}

- (void)dealloc
{
	_delegate = nil; // to avoid late notification
	
#if DTCORETEXT_USES_NSURLSESSION
    for (NSURLSessionDataTask *dataTask in _arrDataTasks) {
        [dataTask cancel];
    }
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    if (_dataTask) {
        [_dataTask cancel];
    }
#pragma GCC diagnostic pop
#else
	[_connection cancel];
#endif
	
	if (_imageSource) CFRelease(_imageSource);
}
- (void)loadImageAtURL:(NSURL *)url
{
	// local files we don't need to get asynchronously
	if ([url isFileURL] || [url.scheme isEqualToString:@"data"])
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSData *data = [NSData dataWithContentsOfURL:url];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[self completeDownloadWithData:data andUrl:url];
			});
		});
		
		return;
	}

	@autoreleasepool 
	{
        if (![self.urlRequestsInfo.allKeys containsObject:url]) {
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
            [self.urlRequestsInfo setObject:urlRequest forKey:url];
        }else{
            NSMutableURLRequest *urlRequest = [self.urlRequestsInfo objectForKey:url];
            [urlRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
            [urlRequest setTimeoutInterval:30.0];
        }
        
        /*
         if (!_urlRequest)
         {
         _urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
         }
         else
         {
         [_urlRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
         [_urlRequest setTimeoutInterval:10.0];
         }
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:DTLazyImageViewWillStartDownloadNotification object:self];
        
#if DTCORETEXT_USES_NSURLSESSION
        
        if (!_session)
        {
            _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        }
        [self.urlRequestsInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSURLRequest *request = obj;
            NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request];
            [self.arrDataTasks addObject:dataTask];
            [dataTask resume];
        }];
        //		_dataTask = [_session dataTaskWithRequest:_urlRequest];
        //		[_dataTask resume];
#else
        _connection = [[NSURLConnection alloc] initWithRequest:_urlRequest delegate:self startImmediately:NO];
        [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_connection start];
#endif
	}
}
- (NSString *)highestQualityImageSizeKeyCached{
    NSString *highestQualitySizeKey;
    for (NSString *sizeKey in self.imageUrlsInfo.allKeys) {
        NSInteger sizeValue = [sizeKey integerValue];
        if (highestQualitySizeKey.integerValue < sizeValue) {
            highestQualitySizeKey = sizeKey;
        }
    }
    return highestQualitySizeKey;
}
- (void)restartLoadImage{
    self.image = nil;
    if (!self.image && (self.imageUrlsInfo.count > 0 || self.urlRequestsInfo.count > 0)
#if DTCORETEXT_USES_NSURLSESSION
        /*&& self.arrDataTasks.count == 0*/
#else
        && !_connection
#endif
        /*&& self.superview*/)
    {
        //FIX: 需要有URL清晰度的描述字段
        NSURL *lastImageUrl;
        UIImage *image;
        if ([self highestQualityImageSizeKeyCached]) {
            lastImageUrl = [self.imageUrlsInfo objectForKey:[self highestQualityImageSizeKeyCached]];
            if (!_imageCache) {
                static dispatch_once_t predicate;
                
                dispatch_once(&predicate, ^{
                    _imageCache = [[NSCache alloc] init];
                });
            }
            
            image = [_imageCache objectForKey:lastImageUrl.absoluteString];
        }
        
        if (image)
        {
            self.image = image;
            _fullWidth = image.size.width;
            _fullHeight = image.size.height;
            
            // this has to be synchronous
            [self _notifyDelegateWithImageUrl:lastImageUrl];
            
            return;
        }
        [self.imageUrlsInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSURL *imageUrl = obj;
            [self loadImageAtURL:imageUrl];
        }];
        
    }
}
- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
	
	if (!self.image && (self.imageUrlsInfo.count > 0 || self.urlRequestsInfo.count > 0)
#if DTCORETEXT_USES_NSURLSESSION
		 /*&& self.arrDataTasks.count == 0*/
#else
		 && !_connection
#endif
		 /*&& self.superview*/)
	{
        //FIX: 需要有URL清晰度的描述字段
        NSURL *lastImageUrl;
        UIImage *image;
        if ([self highestQualityImageSizeKeyCached]) {
            lastImageUrl = [self.imageUrlsInfo objectForKey:[self highestQualityImageSizeKeyCached]];
            if (!_imageCache) {
                static dispatch_once_t predicate;
                
                dispatch_once(&predicate, ^{
                    _imageCache = [[NSCache alloc] init];
                });
            }
            
            image = [_imageCache objectForKey:lastImageUrl.absoluteString];
        }

		if (image)
		{
			self.image = image;
			_fullWidth = image.size.width;
			_fullHeight = image.size.height;
			
			// this has to be synchronous
			[self _notifyDelegateWithImageUrl:lastImageUrl];
			
			return;
		}
        [self.imageUrlsInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSURL *imageUrl = obj;
            [self loadImageAtURL:imageUrl];
        }];

	}	
}

- (void)cancelLoading
{
#if DTCORETEXT_USES_NSURLSESSION
    for (NSURLSessionDataTask *dataTask in self.arrDataTasks) {
        [dataTask cancel];
    }
    [self.arrDataTasks removeAllObjects];
#else
	[_connection cancel];
	_connection = nil;
#endif
    [self.receivedDataInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableData *receiveData = obj;
        [self.arrDataTasks removeObject:receiveData];
    }];
    [self.receivedDataInfo removeAllObjects];
}

#pragma mark Progressive Image
-(CGImageRef)newTransitoryImage:(CGImageRef)partialImg
{
	const size_t height = CGImageGetHeight(partialImg);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	size_t lFullWidth = (size_t)ceil(_fullWidth);
	size_t lFullHeight = (size_t)ceil(_fullHeight);
	CGContextRef bmContext = CGBitmapContextCreate(NULL, lFullWidth, lFullHeight, 8, lFullWidth * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
	CGColorSpaceRelease(colorSpace);
	if (!bmContext)
	{
		// fail creating context
		return NULL;
	}
	CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = _fullWidth, .size.height = height}, partialImg);
	CGImageRef goodImageRef = CGBitmapContextCreateImage(bmContext);
	CGContextRelease(bmContext);
	return goodImageRef;
}
- (void)createAndShowProgressiveImageWithImageIdentifer:(NSURL *)imageUrl
{
    if (!_imageSource)
    {
        return;
    }
    
    /* For progressive download */
    NSMutableData *receiveData = [self.receivedDataInfo objectForKey:imageUrl];
    
    const NSUInteger totalSize = [receiveData length];
    CGImageSourceUpdateData(_imageSource, (__bridge CFDataRef)receiveData, (totalSize == _expectedSize) ? true : false);
    
    if (_fullHeight > 0 && _fullWidth > 0)
    {
        CGImageRef image = CGImageSourceCreateImageAtIndex(_imageSource, 0, NULL);
        if (image)
        {
            CGImageRef imgTmp = [self newTransitoryImage:image]; // iOS fix to correctly handle JPG see : http://www.cocoabyss.com/mac-os-x/progressive-image-download-imageio/
            if (imgTmp)
            {
                UIImage *uimage = [[UIImage alloc] initWithCGImage:imgTmp];
                CGImageRelease(imgTmp);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = uimage;
                } );
            }
            CGImageRelease(image);
        }
    }
    else
    {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(_imageSource, 0, NULL);
        if (properties)
        {
            CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
            if (val)
                CFNumberGetValue(val, kCFNumberFloatType, &_fullHeight);
            val = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
            if (val)
                CFNumberGetValue(val, kCFNumberFloatType, &_fullWidth);
            CFRelease(properties);
        }
    }
}

#pragma mark NSURL Loading

- (void)_notifyDelegateWithImageUrl:(NSURL *)url
{
	if ([self.delegate respondsToSelector:@selector(lazyImageView:didChangeImageSize:andImageUrl:)]) {
		[self.delegate lazyImageView:self didChangeImageSize:CGSizeMake(_fullWidth, _fullHeight) andImageUrl:url];
	}
}

- (void)completeDownloadWithData:(NSData *)data andUrl:(NSURL *)url
{
    __block NSString *currentImageSize;
    NSString *highestImageSize = [self highestQualityImageSizeKeyCached];
    [self.imageUrlsInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSURL *obj, BOOL * _Nonnull stop) {
        if([url.absoluteString isEqualToString:obj.absoluteString]){
            currentImageSize = key;
            *stop = YES;
        }
    }];
    if (highestImageSize.integerValue <= currentImageSize.integerValue) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        self.image = image;
        
        CATransition *transition = [CATransition animation];
        transition.duration = .5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        [self.layer addAnimation:transition forKey:nil];
        
        _fullWidth = image.size.width;
        _fullHeight = image.size.height;
        
        [self _notifyDelegateWithImageUrl:url];
        
        if (!_imageCache) {
            static dispatch_once_t predicate;
            
            dispatch_once(&predicate, ^{
                _imageCache = [[NSCache alloc] init];
            });
        }
        
        
        if (url)
        {
            if (image)
            {
                // cache image
                [_imageCache setObject:image forKey:url.absoluteString];
            }
            else
            {
                DTLogWarning(@"Warning, %@ did not get an image for %@", NSStringFromClass([self class]), [url absoluteString]);
            }
        }
    }
	
}

#if DTCORETEXT_USES_NSURLSESSION
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
#else
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
#endif

	// every time we get an response it might be a forward, so we discard what data we have
    
    NSMutableData *reciveData = nil;
    NSURL *url = response.URL;
    if ([self.receivedDataInfo.allKeys containsObject:url]) {
        [self.receivedDataInfo removeObjectForKey:url];
    }
    
	// does not fire for local file URLs
	if ([response isKindOfClass:[NSHTTPURLResponse class]])
	{
		NSHTTPURLResponse *httpResponse = (id)response;
		
		if (![[httpResponse MIMEType] hasPrefix:@"image"])
		{
#if DTCORETEXT_USES_NSURLSESSION
			completionHandler(NSURLSessionResponseCancel);
#else
			[self cancelLoading];
#endif
			return;
		}
		
#if DTCORETEXT_USES_NSURLSESSION
		completionHandler(NSURLSessionResponseAllow);
#endif
	}
	
	/* For progressive download */
	_fullWidth = _fullHeight = -1.0f;
	_expectedSize = (NSUInteger)[response expectedContentLength];
	
	reciveData = [[NSMutableData alloc] init];
    [self.receivedDataInfo setObject:reciveData forKey:url];
}

#if DTCORETEXT_USES_NSURLSESSION
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    NSURL *url = dataTask.response.URL;

#else
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSURL *url = connection.currentRequest.URL;
#endif
    NSMutableData *receivedData = [self.receivedDataInfo objectForKey:url];
	[receivedData appendData:data];
    [self.receivedDataInfo setObject:receivedData forKey:url];
	if (!&CGImageSourceCreateIncremental || !shouldShowProgressiveDownload)
	{
		// don't show progressive
		return;
	}
	
	if (!_imageSource)
	{
		_imageSource = CGImageSourceCreateIncremental(NULL);
	}
	
	[self createAndShowProgressiveImageWithImageIdentifer:url];
}


- (void)removeFromSuperview
{
	[super removeFromSuperview];
    
#if DTCORETEXT_USES_NSURLSESSION
    for (NSURLSessionDataTask *dataTask in self.arrDataTasks){
        [dataTask cancel];
    }
	[_session invalidateAndCancel];
#else
	[_connection cancel];
#endif
}

#if DTCORETEXT_USES_NSURLSESSION
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
    didCompleteWithError:(nullable NSError *)error{
    NSURL *url = task.response.URL;
#else
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURL *url = connection.currentRequest.URL;
#endif
    
    NSMutableData *receivedData = [self.receivedDataInfo objectForKey:url];
#if DTCORETEXT_USES_NSURLSESSION
	if (error)
	{
		[self connection:nil didFailWithError:error];
		return;
	}
#endif
	if (receivedData)
	{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self completeDownloadWithData:receivedData andUrl:url];
        });
//		[self performSelectorOnMainThread:@selector(completeDownloadWithData:) withObject:_receivedData waitUntilDone:YES];
		
//        [self.receivedDataInfo removeObjectForKey:url];
	}
	
#if DTCORETEXT_USES_NSURLSESSION
//	[_session finishTasksAndInvalidate];
//    [self.arrDataTasks removeAllObjects];
#else
	_connection = nil;
#endif
	
	/* For progressive download */
	if (_imageSource)
		CFRelease(_imageSource), _imageSource = NULL;
	
	CFRunLoopStop(CFRunLoopGetCurrent());

	// success = no userInfo
	[[NSNotificationCenter defaultCenter] postNotificationName:DTLazyImageViewDidFinishDownloadNotification object:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
#if DTCORETEXT_USES_NSURLSESSION
//	[_session invalidateAndCancel];
//    [self.arrDataTasks removeAllObjects];
#else
	_connection = nil;
#endif
//    [self.receivedDataInfo removeAllObjects];
	
	/* For progressive download */
	if (_imageSource)
		CFRelease(_imageSource), _imageSource = NULL;
	
	CFRunLoopStop(CFRunLoopGetCurrent());

	// send completion notification, pack in error as well
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:@"Error"];
	[[NSNotificationCenter defaultCenter] postNotificationName:DTLazyImageViewDidFinishDownloadNotification object:self userInfo:userInfo];
}

#pragma mark Properties

- (void) setUrlRequest:(NSMutableURLRequest *)request
{
	_urlRequest = request;
	self.url = [_urlRequest URL];
}

-(NSDictionary *)imageUrlsInfo{
    if (!_imageUrlsInfo) {
        _imageUrlsInfo = [NSDictionary dictionary];
    }
    return _imageUrlsInfo;
}

-(NSMutableDictionary *)urlRequestsInfo{
    if (!_urlRequestsInfo) {
        _urlRequestsInfo = [NSMutableDictionary dictionary];
    }
    return _urlRequestsInfo;
}

- (NSMutableArray *)arrDataTasks{
    if (!_arrDataTasks) {
        _arrDataTasks = [NSMutableArray array];
    }
    return _arrDataTasks;
}

//-(NSMutableArray *)arrSessions{
//    if (!_arrSessions) {
//        _arrSessions = [NSMutableArray array];
//    }
//    return _arrSessions;
//}

-(NSMutableDictionary *)receivedDataInfo{
    if (!_receivedDataInfo) {
        _receivedDataInfo = [NSMutableDictionary dictionary];
    }
    return _receivedDataInfo;
}
@synthesize delegate = _delegate;
@synthesize shouldShowProgressiveDownload;
@synthesize url = _url;

@synthesize urlRequest = _urlRequest;

@end
