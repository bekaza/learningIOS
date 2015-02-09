//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by manit on 6/2/2558.
//  Copyright (c) พ.ศ. 2558 BIg Nerd Ranch. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController () <UISplitViewControllerDelegate>

@end

@implementation BNRWebViewController

-(void)loadView
{
    UIWebView * webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

-(void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest * req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Courses";
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

//-(void)splitViewController:(UISplitViewController *)svc
//    willShowViewController:(UIViewController *)aViewController
// invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
//    if (barButtonItem == self.navigationItem.leftBarButtonItem) {
//        self.navigationItem.leftBarButtonItem = nil;
//    }
//}

@end
