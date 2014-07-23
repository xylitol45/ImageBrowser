//
//  SourceViewController.m
//  ImageBrowser
//
//  Created by yoshimura on 2013/12/06.
//  Copyright (c) 2013年 yoshimura. All rights reserved.
//

#import "SourceViewController.h"

@interface SourceViewController ()
//@property (weak, nonatomic) IBOutlet UITextView *txtSource;
//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
/*}

- (void)viewWillAppear:(BOOL)animated  {
 
 
    [super viewWillAppear:animated];
  */
    if ([self.html length] == 0) {
        return;
    }
    
    self.highlightView.text = self.html;
    
    [self.highlightView setHighlightDefinitionWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"html" ofType:@"plist"]];

    return;
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    
//    
//    
//    NSString *text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    
//    text = [NSString stringWithFormat:text, self.html];
//    
//    //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
//    
//    NSLog(@"%@", text);
//    
//    [self.webView loadHTMLString:text baseURL: [NSURL fileURLWithPath:path]];
//    
//    return;
//    

    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//
//
//
//    NSString *text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    
////    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
//    
//    [self.webView loadHTMLString:text baseURL: [NSURL fileURLWithPath:path]];
//
//    return;
    
    
    
    
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: self.url]];
//
//    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                                       }];
//    
//    // リクエストを送信する。
//    // 第３引数のブロックに実行結果が渡される。
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        if (error) {
//            return ;
//        }
//        int httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
//        
//        if (httpStatusCode == 404) {
//            return;
//        }
//        
//        NSLog(@"success request!!");
//        
////        NSLog(@"statusCode = %d", ((NSHTTPURLResponse *)response).statusCode);
//        
//        NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                
//                // ここはサブスレッドなので、メインスレッドで何かしたい場合には
//                NSString *_html =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        
//        
//        
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // ここに何か処理を書く。
//                    
////                    self.txtSource.text = _html;
//                    
//                    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//                    
//                    
//                    
//                    NSString *text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//                    
//                    text = [NSString stringWithFormat:text, _html];
//                    
//                    //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
//                    
//                    NSLog(@"%@", text);
//                    
//                    [self.webView loadHTMLString:text baseURL: [NSURL fileURLWithPath:path]];
//
//                    
//                });
//     
//        
//     
//    }];
//    
//    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
