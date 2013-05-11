//
//  TwitterViewController.m
//  triquencyforiphone
//
//  Created by Christoph Wolff on 31.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//

#import "TwitterViewController.h"


@implementation TwitterViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[Twitter loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://twitter.com/triquency"]]];

    
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
	timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(tick) userInfo:nil repeats:YES];
	
	Twitter.opaque = NO;
    Twitter.backgroundColor = [UIColor clearColor];
}

-(void)tick {
	
	if(!Twitter.loading)
		[activityIndicator stopAnimating];
	
	else
		[activityIndicator startAnimating];
	
}

// Reachability.
- (void)webView:(UIWebView *)Twitter didFailLoadWithError:(NSError *)error {
	
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




- (IBAction)backwardsPressed:(id)sender {
    [Twitter goBack];
}

- (IBAction)reloadPressed:(id)sender {
    [Twitter reload];
}

- (IBAction)forwardPressed:(id)sender {
    [Twitter goForward];
}
@end
