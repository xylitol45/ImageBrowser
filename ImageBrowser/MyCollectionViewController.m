//
//  MyCollectionViewController.m
//  ImageBrowser
//
//  Created by セラフ on 2013/11/18.
//  Copyright (c) 2013年 yoshimura. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "LazyImageView.h"

@interface MyCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSCache *imageCache;

@end

@implementation MyCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageCache = [[NSCache alloc] init];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"collectionView %lu", [self.imageArray count]);
    
    
    return [self.imageArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor yellowColor];
    
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;

//    UIImageView *_imageView = (UIImageView *)[cell viewWithTag:1];
//    _imageView.image = [self.imageArray objectAtIndex:indexPath.row];
    
    
    NSString *_url = [self.imageArray objectAtIndex:indexPath.row];
    
//    NSString *imageName = [[self.photos objectAtIndex:indexPath.row] objectForKey:@"fullimage"];
    UIImage *image = [self.imageCache objectForKey:_url];
    UIImageView *view = (UIImageView*)[cell viewWithTag:1];
    
    if(image){
        
        [view setImage:image];
        
    }
    else{
        
        [view setImage:nil];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_url]];
            
            UIImage *image = [UIImage imageWithData:data];
            
            if (image) {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [view setImage:image];
                
                });
            
                [self.imageCache setObject:image forKey:_url];
            }
        });
    }
//
//    
//    
//    NSLog(@"cellForItemAtIndexPath subviews %d", [[cell.contentView subviews] count]);
//    
//    if ([[cell.contentView subviews] count] == 0) {
//        
////        [[UIImageView alloc] initWithFrame:self.contentView.bounds];
//        
//        
////        CGRect rect =
//        
//        NSString *_url = [self.imageArray objectAtIndex:indexPath.row];
//        
//        LazyImageView *lazyImageView =
//            [[LazyImageView alloc] initWithFrame:cell.contentView.bounds withUrl:[NSURL URLWithString:_url]];
//        
//        lazyImageView.contentMode = UIViewContentModeScaleAspectFit;
//        lazyImageView.tag = 1;
//        [lazyImageView startLoadImage];
//
//        [cell.contentView addSubview:lazyImageView];
//
//        NSLog(@"cell %@", _url);
//        
//    }
    
//    label.text = [NSString stringWithFormat:@"ラベル%d", indexPath.row];
    
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        
//        id topGuide = self.topLayoutGuide;
//        CGFloat topBarOffset = self.topLayoutGuide.length; //I checked this valued is 20
//        
//        NSLog(@"toplayoutguide %f", topBarOffset);
//    }

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //クリックされたらよばれる
    NSLog(@"Clicked %d-%d",indexPath.section,indexPath.row);
    
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:1];
    
    NSString *_url = [self.imageArray objectAtIndex:indexPath.row];
    
    //    NSString *imageName = [[self.photos objectAtIndex:indexPath.row] objectForKey:@"fullimage"];
    UIImage *image = [self.imageCache objectForKey:_url];

    
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"画像を保存しました"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil
                              ];
        [alert show];
        
    }
    
}

- (IBAction)closeModalDialog:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
