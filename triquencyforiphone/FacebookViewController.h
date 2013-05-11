//
//  FacebookViewController.h
//  triquencyforiphone
//
//  Created by Christoph Wolff on 19.04.13.
//  Copyright (c) 2013 Christoph Wolff. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FacebookViewController : UIViewController {
	
	IBOutlet UIWebView *Facebook;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSTimer *timer;
   
}
- (IBAction)forwardpressed:(id)sender;
- (IBAction)reloadPressed:(id)sender;
- (IBAction)backwardPressed:(id)sender;

@end