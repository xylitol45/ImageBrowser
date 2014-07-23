//
//  BrowserViewController.m
//  ImageBrowser
//
//  Created by yoshimura on 2013/11/17.
//  Copyright (c) 2013年 yoshimura. All rights reserved.
//

#import <Social/Social.h>

#import "BrowserViewController.h"
#import "MyCollectionViewController.h"
#import "SourceViewController.h"

@interface BrowserViewController ()

@property (nonatomic, weak) IBOutlet UITextField *txtUrl;
@property (nonatomic, weak) IBOutlet UIWebView *myWebView;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation BrowserViewController


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
	// Do any additional setup after loading the view.
    
    // 通知作成
    NSNotificationCenter *_nc = [NSNotificationCenter defaultCenter];
    [_nc addObserver:self selector:@selector(notifyPasteBoard:) name:@"NotifyPasteBoard" object:nil];
    

    self.imageArray = [[NSMutableArray alloc]init];
    
    [self.txtUrl setText:@"http://www.yahoo.co.jp/"];
    
//    [self reloadWeb];
    
    self.myWebView.delegate = self;
    
//    
//    NSURL *url = [NSURL URLWithString:@"http://www.yahoo.co.jp"];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    [wv loadRequest:req];
    
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.txtUrl text]]]];
}

- (void)reloadWeb {
    
    NSString *_urlstring = [self.txtUrl text];
    
    if ([_urlstring length] == 0) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString: _urlstring];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    
    
                       
                       [NSURLConnection sendAsynchronousRequest:request
                                                          queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                          }];
                       
    // リクエストを送信する。
    // 第３引数のブロックに実行結果が渡される。
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            // エラー処理を行う。
            if (error.code == -1003) {
                NSLog(@"not found hostname. targetURL=%@", url);
            } else if (-1019) {
                NSLog(@"auth error. reason=%@", error);
            } else {
                NSLog(@"unknown error occurred. reason = %@", error);
            }
            
        } else {
            int httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (httpStatusCode == 404) {
                NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
                // } else if (・・・) {
                // 他にも処理したいHTTPステータスがあれば書く。
                
            } else {
                NSLog(@"success request!!");
                NSLog(@"statusCode = %d", ((NSHTTPURLResponse *)response).statusCode);
                NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                
                // ここはサブスレッドなので、メインスレッドで何かしたい場合には
                NSString *_html =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSString *_pattern = @"<img[^>]+src=['\"]([^\"']+)[\"']";
                NSError *_error = nil;
                
                NSRegularExpression *regexp = [NSRegularExpression
                                               regularExpressionWithPattern:_pattern
                                               options:0
                                               error: & _error
                                               ];
                NSArray *_array = [regexp matchesInString:_html options:0 range:NSMakeRange(0, [_html length])];
            
                if (_error!=nil) {
                    NSLog(@"error %@", _error);
                }
                
                NSMutableArray *_resultArray = [[NSMutableArray alloc]initWithCapacity:[_array count]];
                
                for (NSTextCheckingResult *result in _array) {
                
                    [_resultArray addObject:[_html substringWithRange:[result rangeAtIndex:1]]];
                    
//                    for (int i = 0; i < [result numberOfRanges]; i++) {
//                        NSRange r = [result rangeAtIndex:i];
//                        NSLog(@"検索結果 %@", [_html substringWithRange:r]);
//                    }
                    
                }
                
                _resultArray = [_resultArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
                
                [self.imageArray removeAllObjects];
                
                
                
                for (NSString *_str in _resultArray) {
    //                NSLog(@"画像 %@", _str);
                    
                    [self saveImage:_str];
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // ここに何か処理を書く。
                    
                    [self.myWebView loadHTMLString:_html baseURL:nil];
                    
                    
                });
            }
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveImage:(NSString*)url
{

    NSLog(@"saveImage %@", url);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    
        UIImage *_image = [[UIImage alloc] initWithData:data];

        dispatch_async(dispatch_get_main_queue(), ^{
            
//            NSLog(@"image %lu", [self.imageArray count]);
            
            if(_image==nil){
                return ;
            }
            
            [self.imageArray addObject:_image];
        });
        
        SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
        
        UIImageWriteToSavedPhotosAlbum(_image, self, selector, nil);

    }];
}

- (void)onCompleteCapture:(UIImage *)screenImage
 didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//    if (error) {
//        NSLog(@"error %@", error);
//    } else {
//        NSLog(@"success");
//    }
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        
//        id topGuide = self.topLayoutGuide;
//        CGFloat topBarOffset = self.topLayoutGuide.length; //I checked this valued is 20
//        
//        NSLog(@"toplayoutguide %f", topBarOffset);
//    }
    
    
}

- (IBAction)onTxtUrlEditingDidEnd:(id)sender {
    
    // UITextField *_view = (UITextField*) sender;
    
    // NSLog(@"onTxtUrlEditingDidEnd %@", [_view text]);

    [self reloadWeb];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Segueの特定
    
    NSLog(@"segue %@",[segue identifier]);
    
    if ( [[segue identifier] isEqualToString:@"move MyCollectionViewController"] ) {
        MyCollectionViewController *nextViewController = [segue destinationViewController];
        //ここで遷移先ビューのクラスの変数receiveStringに値を渡している
        //nextViewController.receiveString = sendString;
        
        NSLog(@"prepareForSegue %@ %lu", [segue identifier], (unsigned long)[self.imageArray count]);
        nextViewController.imageArray = self.imageArray;
    } else if( [[segue identifier] isEqualToString:@"open SourceViewController"] ) {
        SourceViewController *nextViewController = [segue destinationViewController];
        
        
        
        NSString* html = [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML"];
//        NSString* html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        
//        NSLog(@"txtUrl.text %@", self.txtUrl.text);
//        
//        nextViewController.url =  self.txtUrl.text;
//        
        nextViewController.html = html;
    }
}

-(void)webViewDidFinishLoad:(UIWebView*)webView{
    
    self.txtUrl.text = [webView stringByEvaluatingJavaScriptFromString:
                        @"document.location.href"];

    
    
    NSString *_body = [webView stringByEvaluatingJavaScriptFromString:
                      @"document.body.innerHTML"];

    NSString *_pattern = @"<img[^>]+src=['\"]([^\"']+\\.(jpg|jpeg|png))[\"']";
    NSError *_error = nil;
    
    NSRegularExpression *regexp = [NSRegularExpression
                                   regularExpressionWithPattern:_pattern
                                   options:0
                                   error: & _error
                                   ];
    NSArray *_array = [regexp matchesInString:_body options:0 range:NSMakeRange(0, [_body length])];
    
    if (_error!=nil) {
        NSLog(@"error %@", _error);
    }
    
    NSMutableArray *_resultArray = [[NSMutableArray alloc]initWithCapacity:[_array count]];
    
    for (NSTextCheckingResult *result in _array) {
        
        [_resultArray addObject:[_body substringWithRange:[result rangeAtIndex:1]]];
        
    }
    
    _resultArray = [_resultArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    [self.imageArray removeAllObjects];
    for (NSString *_str in _resultArray) {
        //                NSLog(@"画像 %@", _str);
        //        [self saveImage:_str];
        [self.imageArray addObjectsFromArray:_resultArray];
    }



}

- (void)notifyPasteBoard:(NSNotification*) notification{
    // 通知の送信側から送られた値を取得する

    NSLog(@"notifyPasteBoard");
    
    UIViewController *_viewController = [self presentedViewController];
    
    if (_viewController!=nil) {
        [_viewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    self.txtUrl.text = [[notification userInfo] objectForKey:@"url"];
//    self.txtUrl.text = [[center userInfo] objectForKey:@"url"];
    [self reloadWeb];
    
//    NSDictionary _dict = [[center userInfo] obj]

}

- (IBAction)onReload:(id)sender {
    [self reloadWeb];
}


- (IBAction)onPressedTest:(id)sender {
    NSString *text = @"Hello World!";
    NSArray* actItems = [NSArray arrayWithObjects:text, nil];
    
    UIActivityViewController *activityView =
        [[UIActivityViewController alloc] initWithActivityItems:actItems applicationActivities:nil];
    
    [self presentViewController:activityView animated:YES completion:^{
    }];

}

- (IBAction)onTW:(id)sender {

    // postのクライアント表示はiOSになる。
    SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterPostVC setInitialText:@"iOSのSocialFrameworkから投稿テスト。\nSLComposeViewController簡単。"];
    [self presentViewController:twitterPostVC animated:YES completion:nil];

}

- (IBAction)onFB:(id)sender {
    // postのクライアント表示はiOSになる。
    SLComposeViewController *twitterPostVC =
        [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [twitterPostVC setInitialText:@"iOSのSocialFrameworkから投稿テスト。\nFacebook"];
    [self presentViewController:twitterPostVC animated:YES completion:nil];
}
- (IBAction)onGoBack:(id)sender {
    if ([self.myWebView canGoBack]) {
        [self.myWebView goBack];
    }
}
- (IBAction)onGoForward:(id)sender {
    if ([self.myWebView canGoForward]){
        [self.myWebView goForward];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // the user pressed the "Done" button, so dismiss the keyboard
    // キーボードを非表示にする
    [textField resignFirstResponder];
    
    [self reloadWeb];
    
    return YES;

}


@end
