//
//  PhotoDownloadViewController.h
//  PhotoDownload
//
//  Created by Nguyen on 12/18/13.
//  Copyright (c) 2013 Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDownloadViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progress;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (strong, nonatomic) IBOutlet UIButton *triggerButton;
@property (strong, nonatomic) NSURLConnection *urlConnection;

@end
