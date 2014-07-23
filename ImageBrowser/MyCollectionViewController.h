//
//  MyCollectionViewController.h
//  ImageBrowser
//
//  Created by セラフ on 2013/11/18.
//  Copyright (c) 2013年 yoshimura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, weak) NSMutableArray *imageArray;

@end
