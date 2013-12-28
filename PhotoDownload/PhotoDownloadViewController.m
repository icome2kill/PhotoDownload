//
//  PhotoDownloadViewController.m
//  PhotoDownload
//
//  Created by Nguyen on 12/18/13.
//  Copyright (c) 2013 Nguyen. All rights reserved.
//

#import "PhotoDownloadViewController.h"

#define START 1
#define STOP 2

@interface PhotoDownloadViewController ()

@end

@implementation PhotoDownloadViewController {
    long long total;
    NSMutableData *tempData;
    float time;
    int buttonStatus;
}

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
    // Do any additional setup after loading the view from its nib.
    self.url.delegate = self;
    self.indicator.hidden = true;
    self.indicator.hidesWhenStopped = YES;
    
    self.progress.text = @"0 %";
    self.progressBar.progress = 0.0f;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    buttonStatus = START;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

- (IBAction)submitClicked:(UIButton *)sender {
    if (buttonStatus == START) {
        [self setUpDefaultViews];
        
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        buttonStatus = STOP;
        tempData = [[NSMutableData alloc] init];
        
        total = 0;
        time = CACurrentMediaTime();
        
        if (self.imageView.image) {
            self.imageView.image = nil;
        }
        
        NSURL *url = [NSURL URLWithString:self.url.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        [self.urlConnection start];
        [self.indicator startAnimating];
    }
    else if (buttonStatus == STOP) {
//        [sender setTitle:@"Start" forState:UIControlStateNormal];
        buttonStatus = START;
        
        [self setUpDefaultViews];
        
        [self.urlConnection cancel];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [self.view setFrame:CGRectMake(0,-200,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    [UIView commitAnimations];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [self.view setFrame:CGRectMake(0,0,320,460)];
    [UIView commitAnimations];
}

- (void) setUpDefaultViews {
    [self.triggerButton setTitle:@"Start" forState:UIControlStateNormal];
    self.progress.text = @"0 %";
    self.progressBar.progress = 0.0f;
    self.speed.text = @"Speed: 0.0KB/s";
    [self.indicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.indicator stopAnimating];
    NSLog(@"%@",error.description);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Bad URL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    long progress = 0;
    float dif = CACurrentMediaTime() - time;
    
    if (data) {
        [tempData appendData:data];
        progress = tempData.length;
        self.speed.text = [NSString stringWithFormat:@"Speed %2.2fKB/s", (float)progress / (dif * 1024)];
    }
    float progressValue = (float)progress / total;
    self.progress.text = [NSString stringWithFormat:@"%2.2f %%", progressValue * 100];
    self.progressBar.progress = progressValue;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSString *res = [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode];
    NSString *fulRes = [NSString stringWithFormat:@"%d %@", httpResponse.statusCode, res];
    switch (httpResponse.statusCode) {
        case 200:
            break;
        default:
            [[[UIAlertView alloc] initWithTitle:@"Error" message:fulRes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            break;
    }
    total = response.expectedContentLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (tempData) {
        self.imageView.image = [UIImage imageWithData:tempData];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong :(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    [self.triggerButton setTitle:@"Start" forState:UIControlStateNormal];
    buttonStatus = START;
    
    [self.indicator stopAnimating];
}

@end
