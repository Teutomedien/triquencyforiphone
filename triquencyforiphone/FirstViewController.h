//
//  FirstViewController.h
//  triquencyforiphone
//
//  Created by Christoph Wolff on 26.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>



@interface FirstViewController : UIViewController<AVAudioSessionDelegate>{
    
    float radians;
    float degrees;
}

@property (strong, nonatomic) IBOutlet UIButton *playpausebutton;

@property (strong, nonatomic) IBOutlet UILabel *currentTrackTitle;

@property (strong, nonatomic) AVPlayer *radiosound;

@property (strong, nonatomic) IBOutlet UIToolbar *buttomToolbar;

@property (strong, nonatomic) IBOutlet UISegmentedControl *streamquali;

@property (strong, nonatomic) IBOutlet UIButton *innerLoadingImage;

- (IBAction)playpause:(id)sender;

- (IBAction)tweetPressed:(id)sender;

- (IBAction)postPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingTrackActivity;

@property (strong, nonatomic) IBOutlet UIButton *fb_btn;
@property (strong, nonatomic) IBOutlet UIButton *twitter_btn;
@property (strong, nonatomic) IBOutlet UIImageView *UIBGImage;

@property (strong, nonatomic) NSString *u;

@property (strong, nonatomic) IBOutlet UIButton *bigPlayBtn;

@property (strong, nonatomic) NSTimer *currentTrackTimer;

@property (strong,nonatomic) NSURL *playing;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property (strong, nonatomic) IBOutlet UINavigationBar *navBarTools;

@property (strong, nonatomic) NSTimer *timer;

- (void)updatecurrenttrack;


@end


