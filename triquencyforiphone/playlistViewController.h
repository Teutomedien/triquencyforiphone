//
//  playlistViewController.h
//  triquencyforiphone
//
//  Created by Christoph Wolff on 31.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playlistViewController : UIViewController
{
    NSArray *items;
    NSArray *tableData;
    NSTimer *timer;
    NSDictionary *json;
    NSMutableArray *_SongArray;

}
- (IBAction)xPlaylistPressed:(id)sender;


@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *withoutLastItem;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSArray *tableData;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingPlaylist;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic,strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic, strong) NSMutableArray *SongArray;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *playlistLoader;
@property (nonatomic,strong) UIRefreshControl *refreshcontrole;
@end
