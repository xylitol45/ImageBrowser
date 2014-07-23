//
//  LazyImageView.h
//  ImageBrowser
//
//  Created by セラフ on 2013/12/17.
//  Copyright (c) 2013年 yoshimura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LazyImageView : UIImageView

// Use this initializer.
- (id)initWithFrame:(CGRect)frame withUrl:(NSURL *)url;

// Start load the image of the specified url.
// Doesn't load the image if an image has been already set.
- (void)startLoadImage;

// Reload load the image of the specified url.
// Load the image even if a connection was already created.
- (void)reloadImage;

// Cancel loading if requesting.
- (void)cancelLoading;

// Set the url of the image to reqeust.
@property (nonatomic, retain) NSURL *imageUrl;

@end