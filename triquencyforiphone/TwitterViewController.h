//
//  TwitterViewController.h
//  triquencyforiphone
//
//  Created by Christoph Wolff on 31.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterViewController : UIViewController {
	
	IBOutlet UIWebView *Twitter;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSTimer *timer;
    NSOperationQueue *queue;
    
}
- (IBAction)backwardsPressed:(id)sender;
- (IBAction)reloadPressed:(id)sender;
- (IBAction)forwardPressed:(id)sender;

@end
