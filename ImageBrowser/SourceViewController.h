//
//  SourceViewController.h
//  ImageBrowser
//
//  Created by yoshimura on 2013/12/06.
//  Copyright (c) 2013年 yoshimura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegexHighlightView.h"

@interface SourceViewController : UIViewController

@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *html;
@property (weak, nonatomic) IBOutlet RegexHighlightView *highlightView;

@end
