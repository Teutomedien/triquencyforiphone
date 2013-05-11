//
//  playlistViewController.m
//  triquencyforiphone
//
//  Created by Christoph Wolff on 31.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//

#import "playlistViewController.h"
#import "playlistSong.h"

@interface playlistViewController ()

@end

@implementation playlistViewController

@synthesize myTable;
@synthesize items;
@synthesize tableData;
@synthesize loadingPlaylist;
@synthesize withoutLastItem;
@synthesize timer;
@synthesize json;
@synthesize queue;
@synthesize SongArray = _SongArray;
@synthesize playlistLoader;
@synthesize refreshcontrole;



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
 

    myTable.frame = CGRectMake(0.0, myTable.frame.origin.y + 44, myTable.frame.size.width, myTable.frame.size.height-30);
    self.myTable.bounces = YES;
    self.myTable.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
    refreshcontrole = [[UIRefreshControl alloc] init];
    refreshcontrole.tintColor = [UIColor colorWithRed:43.0/255.0 green:178.0/255.0 blue:76.0/255.0 alpha:1.0];
    [refreshcontrole addTarget:self action:@selector(refreshPlaylistdata) forControlEvents:UIControlEventValueChanged];
    [self.myTable addSubview:refreshcontrole];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];

    [self loadPlaylistData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)refreshPlaylistdata{
    [self loadPlaylistData];
    
}
-(void)loadPlaylistData{

    queue =[[NSOperationQueue alloc]init];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:  [NSURL URLWithString:@"http://itgeek.de/codeingstuff/fancytool.php?o=json"]];
    [NSURLConnection sendAsynchronousRequest: urlRequest queue: queue completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if(!error)
         {
             [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
             
             
         }
         else
         {
             //Error - Handeled by the Reachability Class
         }
     }];
   
}
- (void)fetchedData:(NSData *)responseData {
    
    NSError* error;
    json = [NSJSONSerialization
            JSONObjectWithData:responseData
            options:kNilOptions
            error:&error];
    
    
    _SongArray = [[NSMutableArray alloc]init];

    NSDictionary* latestSongs = [json objectForKey:@"results"]; //2d
    
    for (NSDictionary *Song in latestSongs)
    {
        playlistSong *playlistSongObj = [[playlistSong alloc]init];
        
        
        playlistSongObj.Title = [Song objectForKey:@"title"];
        
        playlistSongObj.artist = [Song objectForKey:@"artist"];
     
        playlistSongObj.Time = [Song objectForKey:@"timetext"];

        
        [_SongArray addObject:playlistSongObj];
        

    }
    
   
    [myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.refreshcontrole endRefreshing];


    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
   // return [[json valueForKey:@"results"] count];
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[json valueForKey:@"results"] valueForKey:@"timetext"]count];
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [[self myTable] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"songCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    playlistSong *eventLcl = (playlistSong *)[_SongArray objectAtIndex:[indexPath row]];
    
    
    // Assign our own background image for the cell
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;

    

    UILabel *ArtistLabel = (UILabel *)[cell viewWithTag:102];
        
    UILabel *timeStampLabel = (UILabel *)[cell viewWithTag:101];
    
    UILabel *songNameLabel = (UILabel *)[cell viewWithTag:100];
    
    songNameLabel.text = (NSString*)eventLcl.Title;
    
    timeStampLabel.text = (NSString*)eventLcl.Time;
    
    ArtistLabel.text = (NSString*)eventLcl.Artist;
  

  
    [playlistLoader stopAnimating];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    return cell;
    
}
- (void)viewDidUnload
{
    [self setWithoutLastItem:nil];
    [self setMyTable:nil];
    [self setTableData:nil];
    [self setItems:nil];
    [self setLoadingPlaylist:nil];
    [self setJson:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)xPlaylistPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
