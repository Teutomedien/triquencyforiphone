//
//  FacebookViewController.m
//  triquencyforiphone
//
//  Created by Christoph Wolff on 19.04.13.
//  Copyright (c) 2013 Christoph Wolff. All rights reserved.
//

#import "FacebookViewController.h"


@implementation FacebookViewController



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[Facebook loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.facebook.com/triquency"]]];
    
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
	timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(tick) userInfo:nil repeats:YES];
	
	Facebook.opaque = NO;
    Facebook.backgroundColor = [UIColor clearColor];
	
}

-(void)tick {
	
	if(!Facebook.loading)
		[activityIndicator stopAnimating];
	
	else
		[activityIndicator startAnimating];
	
}


// Reachability.
- (void)webView:(UIWebView *)Facebook didFailLoadWithError:(NSError *)error {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Webview did not load. Please check your internet connection and refresh the page." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[alert show];

	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (IBAction)forwardpressed:(id)sender {
    
    [Facebook goForward];
}

- (IBAction)reloadPressed:(id)sender {
    [Facebook reload];
}

- (IBAction)backwardPressed:(id)sender {
    [Facebook goBack];
}
@end
