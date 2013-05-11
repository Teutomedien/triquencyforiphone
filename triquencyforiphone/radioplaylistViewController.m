//
//  radioplaylistViewController.m
//  triquencyforiphone
//
//  Created by Christoph Wolff on 29.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//

#import "radioplaylistViewController.h"

@interface radioplaylistViewController ()

@end

@implementation radioplaylistViewController

@synthesize withoutLastItem;
@synthesize loadingPlaylist;
@synthesize playlistBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    playlistBar.barStyle = UIBarStyleBlackTranslucent;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:  [NSURL URLWithString:@"http://www.triquency.de/playlist.php"]];
    
    [NSURLConnection sendAsynchronousRequest: urlRequest queue: queue completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
        
        
        //pull the content from the file into memory
        //convert the bytes from the file into a string
        NSString* string = [[NSString alloc] initWithBytes:[data bytes]
                                                    length:[data length]
                                                  encoding:NSUTF8StringEncoding];
        
        //split the string around newline characters to create an array
        NSString* delimiter = @"\r";
        NSArray *items = [string componentsSeparatedByString:delimiter];
        withoutLastItem = [[NSMutableArray alloc] initWithArray:items];
        
        [withoutLastItem removeLastObject];
        
        
        NSLog(@"The content of arry is%@",withoutLastItem);
        // Do any additional setup after loading the view.
        
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        [self.tableView performSelectorOnMainThread: @selector(reloadData) withObject: nil waitUntilDone: NO];
    }];
}

- (void)viewDidUnload
{
    [self setLoadingPlaylist:nil];
    [self setPlaylistBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
   return [self.withoutLastItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.withoutLastItem objectAtIndex:indexPath.row];
    
    [loadingPlaylist stopAnimating];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    return cell;
    
}

/*-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    return NO;
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}*/


- (IBAction)donePressed:(id)sender {
   [self dismissModalViewControllerAnimated:YES];
}
@end
