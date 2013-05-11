//
//  radioplaylistViewController.h
//  triquencyforiphone
//
//  Created by Christoph Wolff on 29.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface radioplaylistViewController : UITableViewController
- (IBAction)donePressed:(id)sender;

@property (strong, nonatomic) NSMutableArray *withoutLastItem;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingPlaylist;
@property (strong, nonatomic) IBOutlet UINavigationBar *playlistBar;

@end
