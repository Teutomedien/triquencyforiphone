//
//  FirstViewController.m
//  triquencyforiphone
//
//  Created by Christoph Wolff on 26.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)




#import "FirstViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>





@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize timer;
@synthesize playpausebutton;
@synthesize currentTrackTitle;
@synthesize u;
@synthesize currentTrackTimer;
@synthesize playing;
@synthesize loading;
@synthesize navBarTools;
@synthesize radiosound;
@synthesize buttomToolbar;
@synthesize streamquali;
@synthesize UIBGImage;
@synthesize loadingTrackActivity;
@synthesize bigPlayBtn;
@synthesize innerLoadingImage;
@synthesize twitter_btn;
@synthesize fb_btn;

UIBarButtonItem *startStopButton = nil;
UIBarButtonItem *playbutton;
UIBarButtonItem *pausebutton;

NSString *postCurrentTrack;

bool helper = true;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        [twitter_btn setHidden:TRUE];
        [fb_btn setHidden:TRUE];
    }
    
    float osVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (osVersion >=6.0)
    {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playafterphonecall:) name:AVAudioSessionInterruptionNotification object:nil];
    }
    else
    {
        AVAudioSession* session = [AVAudioSession sharedInstance];
        session.delegate = self;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
     
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory);
    
    AudioSessionSetActive(true);
    [self becomeFirstResponder];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    UIImageView *imgv = [self UIBGImage];
    
    UIImage *img;
    
    if(result.height == 480)
    {
        img = [UIImage imageNamed:@"DefaultBG.png"];
    } else if ([UIScreen mainScreen].bounds.size.height == 568) {
        // iPhone 5
        img = [UIImage imageNamed:@"Default-568hBG@2x"];
    }
    
    [imgv setImage:img];
    
    
    //Second Cycle for animation standard hide on load
    [innerLoadingImage setHidden:TRUE];
    
    [loading stopAnimating];
    [loading hidesWhenStopped];
    loading.alpha = 0;
    [self updatecurrenttrack];

    
}
-(void)playafterphonecall:(NSNotification*)notification{
    NSUInteger type = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    switch (type) {
        case AVAudioSessionInterruptionTypeBegan:
             NSLog(@"radiosound pause");
            break;
        case AVAudioSessionInterruptionTypeEnded:
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
               
            [radiosound play];
                 NSLog(@"radiosound play");
            } else {
                // Have to wait for the app to become active, otherwise
                // the audio session won’t resume correctly.
            }
            break;
    }

}
- (void)appDidFinishedLauning:(NSNotification *)notification {
    //Update Current Track label with Timer
    
}


- (void)appDidBecomeActive:(NSNotification *)notification {

    // Do any additional setup after loading the view, typically from a nib.
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    if ((internetStatus == ReachableViaWiFi) || (internetStatus == ReachableViaWWAN)){
        
        currentTrackTimer = [NSTimer scheduledTimerWithTimeInterval:(60.0) target:self selector:@selector(updatecurrenttrack) userInfo:nil repeats:YES];
        
        
            
        // share instance for audio remote control
        // Registers this class as the delegate of the audio session.
        [[AVAudioSession sharedInstance] setDelegate: self];
        
        // Allow the app sound to continue to play when the screen is locked.
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];  
        
    }
    
    else{
        UIAlertView *errorView;
        
        errorView = [[UIAlertView alloc]
                     initWithTitle: (NSLocalizedString(@"networkerrorTitle", nil))
                     message: (NSLocalizedString(@"networkerror", nil))
                     delegate: self
                     cancelButtonTitle: (NSLocalizedString(@"close", nil)) otherButtonTitles: nil];
        
        [errorView show];
    }
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    
    
    //When user clicks fast away from the FirstViewController
    int len = [postCurrentTrack length];
    if(len != 0){
        currentTrackTitle.text = postCurrentTrack;
    }
    [self updatecurrenttrack];
    
    
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    NSLog(@"remoteControlReceivedWithEvent: %@", event);
    if (event.type==UIEventTypeRemoteControl) {
        if (event.subtype==UIEventSubtypeRemoteControlPlay) {
            NSLog(@"Play");
            
        } else if (event.subtype==UIEventSubtypeRemoteControlPause) {
            NSLog(@"Pause");
            
        } else if (event.subtype==UIEventSubtypeRemoteControlTogglePlayPause) {
            NSLog(@"Play Pause");
            
            if ([radiosound rate] != 0.0){
                [self pauseCurrentTrack];
            } else{
                [self playCurrentTrack];
            }
        }
    }
    
}

-(void)buffering {
	
    if (self.radiosound.currentItem.playbackLikelyToKeepUp == NO)
    {
        [loading startAnimating];
        
        loading.alpha = 1;
        playpausebutton.alpha = 0;
        
    } else {

        //Remove all Animations when playing and hide the second animation cycle
        [bigPlayBtn.layer removeAllAnimations];
        [innerLoadingImage.layer removeAllAnimations];
        [innerLoadingImage setHidden:TRUE];
        
        
        playpausebutton.alpha = 1.0;
        
        loading.alpha = 0;
        
        [self.playpausebutton setImage:[UIImage imageNamed:@"mystopbutton.png"] forState:UIControlStateNormal];
        
        [self.bigPlayBtn setImage:[UIImage imageNamed:@"pause_btn.png"] forState:UIControlStateNormal];
        
    }
    
}
- (void)viewDidUnload
{
    
    [self setCurrentTrackTitle:nil];
    [self setTimer:nil];
    [self setStreamquali:nil];
    [self setButtomToolbar:nil];
    [self setLoading:nil];
    [self setNavBarTools:nil];
    [self setPlaypausebutton:nil];
    [self setInnerLoadingImage:nil];
    [self setFb_btn:nil];
    [self setTwitter_btn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)playCurrentTrack
{
    
    [self.bigPlayBtn setImage:[UIImage imageNamed:@"loading_btn.png"] forState:UIControlStateNormal];
    
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.repeatCount = 200;
    fullRotation.duration = 1;
    
    
    
    CABasicAnimation *fullRotationouta = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotationouta.fromValue = [NSNumber numberWithFloat:0];
    fullRotationouta.toValue = [NSNumber numberWithFloat:((-360*M_PI)/180)];
    fullRotationouta.repeatCount = 200;
    fullRotationouta.duration = 1;
    
    
    
    [innerLoadingImage setHidden:false];
    
    [bigPlayBtn.layer addAnimation:fullRotation forKey:@"360"];
    
    [innerLoadingImage.layer addAnimation:fullRotationouta forKey:@"-360"];
    
    // Indicator View
	timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(buffering) userInfo:nil repeats:YES];
    
    if(streamquali.selectedSegmentIndex == 0){
        u = @"http://livestream.triquency.de:8000/live192.mp3.m3u";
    }
    if(streamquali.selectedSegmentIndex == 1){
        u = @"http://livestream.triquency.de:8000/live128.mp3.m3u";
    }
    NSURL *url = [NSURL URLWithString:u];
	//  AVPlayer *radiosound = [[AVPlayer alloc] initWithURL:url];
	radiosound = [[AVPlayer alloc] initWithURL:url];
    
    
    if (helper == true){
        Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
        NetworkStatus internetStatus = [r currentReachabilityStatus];
        if (internetStatus == ReachableViaWWAN){
            UIAlertView *WWANView;
            
            WWANView = [[UIAlertView alloc]
                        initWithTitle: NSLocalizedString(@"watchout", nil)
                        message: NSLocalizedString(@"nowifi", nil)
                        delegate: self
                        cancelButtonTitle: NSLocalizedString(@"close", nil)
                        otherButtonTitles: nil];
            [WWANView show];
            helper = false;
            
        }
    }
    if ([MPNowPlayingInfoCenter class])
    {
        /* we're on iOS 5, so set up the now playing center */
        UIImage *albumArtImage = [UIImage imageNamed:@"albumCoverTriquency.png"];
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:albumArtImage];
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:postCurrentTrack, MPMediaItemPropertyTitle, albumArt, MPMediaItemPropertyArtwork, nil];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = dict;
    }
    
    [self.radiosound play];
    

    

}

-(void)pauseCurrentTrack
{
    
         [bigPlayBtn.layer removeAllAnimations];
    [timer invalidate];
    [loading stopAnimating];
    [loading hidesWhenStopped];
    loading.alpha = 0;
    
    [self.radiosound pause];
    
    [self.playpausebutton setImage:[UIImage imageNamed:@"myplaybutton.png"] forState:UIControlStateNormal];
    
    [self.bigPlayBtn setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
    
    NSLog(@"pause");
    

	radiosound = nil;

}

- (IBAction)playpause:(id)sender {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    if (radiosound == nil) {
       
        [self playCurrentTrack];
        
	}
	else{
        
		[self pauseCurrentTrack];
        
	}
    
    
}

- (IBAction)tweetPressed:(id)sender {
    if (NSClassFromString(@"SLRequest") != Nil) {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        
        
        [tweetSheet setInitialText:[NSString stringWithFormat:NSLocalizedString(@"Tweetpost",nil),postCurrentTrack]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:NSLocalizedString(@"notweet", nil)
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    }
}

- (IBAction)postPressed:(id)sender {
    if (NSClassFromString(@"SLRequest") != Nil) {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *postSheet =[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        
        [postSheet setInitialText:[NSString stringWithFormat:NSLocalizedString(@"FBPost", nil), postCurrentTrack]];
        
        [self presentViewController:postSheet animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:NSLocalizedString(@"nopost", nil)
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    }
    
}



-(void) updatecurrenttrack{
    
    
    NSString *urlAsString = @"http://user7.webspace.hs-owl.de/triquency.php";
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if (error == nil)
         {
             postCurrentTrack = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             currentTrackTitle.text = postCurrentTrack;
             [loadingTrackActivity stopAnimating];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
         }
         
     }];
    
    
}




@end
