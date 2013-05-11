//
//  playlistTableView.m
//  triquencyforiphone
//
//  Created by Christoph Wolff on 28.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//

#import "playlistTableView.h"

@implementation playlistTableView
@synthesize items;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        
    }
    return self;
}

-(void) viewDidApear{
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:  [NSURL URLWithString:@"http://triquency.de/playlist.php"]];
    
    [NSURLConnection sendAsynchronousRequest: urlRequest queue: queue completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
        
        
        //pull the content from the file into memory
        //convert the bytes from the file into a string
        NSString* string = [[NSString alloc] initWithBytes:[data bytes]
                                                    length:[data length]
                                                  encoding:NSUTF8StringEncoding];
        
        //split the string around newline characters to create an array
        NSString* delimiter = @"\n";
        items = [string componentsSeparatedByString:delimiter];
        NSLog(@"The content of arry is%@",items);
        // Do any additional setup after loading the view.
        
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
    }];

   
}

-(void) viewDidLoad{
    [self.tableHeaderView performSelectorOnMainThread: @selector(reloadData) withObject: nil waitUntilDone: NO];
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
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    return cell;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
