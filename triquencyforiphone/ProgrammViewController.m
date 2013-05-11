//
//  ProgrammViewController.m
//  triquencyforiphone
//
//  Created by Christoph Wolff on 26.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//

#import "ProgrammViewController.h"
#import "ISO8601DateFormatter.h"


@interface ProgrammViewController ()

-(void)LoadCalendarData;
- (void)fetchedData:(NSData *)responseData;
-(void)refreshControlTable;
@end

@implementation ProgrammViewController


@synthesize EventArray = _EventArray;
@synthesize selectedRow;
@synthesize myProgrammTable;
@synthesize loadingProgramm;
@synthesize queue;
@synthesize refreshControl;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
									 initWithTitle:@"Back"
									 style:UIBarButtonItemStylePlain
									 target:self
									 action:@selector(cancel:)];
    
    
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    

    self.myProgrammTable.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //MBProgress by https://github.com/jdg/ !!
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"caldone", nil);
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:43.0/255.0 green:178.0/255.0 blue:76.0/255.0 alpha:1.0];
    [refreshControl addTarget:self action:@selector(refreshControlTable) forControlEvents:UIControlEventValueChanged];
    [self.myProgrammTable addSubview:refreshControl];
    [loadingProgramm startAnimating];
    [self LoadCalendarData];
    
}

- (void)viewDidUnload
{
    myProgrammTable = nil;
    [self setLoadingProgramm:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(IBAction)cancel:(id)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
   
    self.myProgrammTable.rowHeight = 120;
    
   
    [myProgrammTable setHidden:NO];
    [super viewWillAppear:animated];
   
  
}

-(void) refreshControlTable{
    [self LoadCalendarData];
}

- (void)viewDidAppear:(BOOL)animated
{
     
    
    
    
    [myProgrammTable setHidden:NO];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int mcount =[_EventArray count];
    // Return the number of rows in the section.
    return mcount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    GoogCal *eventLcl = (GoogCal *)[_EventArray objectAtIndex:[indexPath row]];
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *locale = [NSLocale currentLocale];
    [dateFormat setLocale:locale];
    //[dateFormat setDateFormat:@"M/dd/yyyy"];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *startDateStr = [dateFormat stringFromDate:eventLcl.StartDate];
    
    
    
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", startDateStr, eventLcl.Title ];
    
    
    cell.detailTextLabel.numberOfLines = 2;
    
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *hoursOpen = [NSString stringWithFormat: NSLocalizedString(@"fromto", nil), [dateFormat stringFromDate:eventLcl.StartDate], [dateFormat stringFromDate:eventLcl.EndDate]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@" ,hoursOpen, eventLcl.Description];
    
    
    //EventButton
    UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"Calendar-iconTriquency.png"];
    [button addTarget:self action:@selector(ShowEventAddSheet:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    button.tag = [indexPath row];
    button.frame = CGRectMake(0.0, 0.0, 48, 48);
    
    cell.accessoryView = button;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    return cell;
}


-(IBAction)ShowEventAddSheet:(id)sender
{
    NSInteger tid = ((UIControl*)sender).tag;
    selectedRow = tid;
    AddEventSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"caladd", nil)
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"calno", nil)
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:NSLocalizedString(@"calyes", nil),Nil];
    // Show the sheet
    [AddEventSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}




-(void)LoadCalendarData
{
    queue =[[NSOperationQueue alloc]init];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:  [NSURL URLWithString:@"http://www.google.com/calendar/feeds/triquency.de_fsmkvg1iokgfcenlrcsa73if3s@group.calendar.google.com/public/full?alt=json&orderby=starttime&max-results=20&singleevents=true&sortorder=ascending&futureevents=true"]];
    [NSURLConnection sendAsynchronousRequest: urlRequest queue: queue completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if(!error)
        {
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:NO];
           
            
        }
        else
        {
         //Error - Grabbing this with the reachability Class
        }
    }];    
    
}


- (void)fetchedData:(NSData *)responseData {
    _EventArray = [[NSMutableArray alloc]init];
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    //NSMutableArray *Week;
    
    NSDictionary* jsonEventFeed = [json objectForKey:@"feed"]; //2d
    NSArray* arrEvent = [jsonEventFeed objectForKey:@"entry"];
    for (NSDictionary *event in arrEvent)
    {
        GoogCal *googCalObj = [[GoogCal alloc]init];
        
        NSDictionary *title = [event objectForKey:@"title"];
        googCalObj.Title = [title objectForKey:@"$t"];
        
        
        //dates are stored in an array
        NSArray *dateArr = [event objectForKey:@"gd$when"];
        for(NSDictionary *dateDict in dateArr)
        {
            
            NSLocale *enUSPOSIXLocale;
            enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            ISO8601DateFormatter *formatter = [[ISO8601DateFormatter  alloc] init];
            
            NSDate *endDate = [formatter dateFromString:[dateDict objectForKey:@"endTime"]];
            NSDate *startDate = [formatter dateFromString:[dateDict objectForKey:@"startTime"]];
            formatter = nil;
            
            googCalObj.EndDate = endDate;
            googCalObj.StartDate = startDate;

            
        }
        
        
        
        
        NSDictionary *content = [event objectForKey:@"content"];
        googCalObj.Description = [content objectForKey:@"$t"];
 
        [_EventArray addObject:googCalObj];
        
    }
    if(_EventArray == nil){
     [myProgrammTable reloadData];
    }
    [myProgrammTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [loadingProgramm stopAnimating];
    [self.refreshControl endRefreshing];
}


#pragma mark - Action Sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self AddEventToCalendar];
    }
}

-(void)AddEventToCalendar
{
    
    [HUD show:YES];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if([self checkIsDeviceVersionHigherThanRequiredVersion:@"6.0"]) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            if (granted){

                //---- codes here when user allow your app to access theirs' calendar.
                GoogCal *calEvent = [[GoogCal alloc]init];
                
                calEvent = [_EventArray objectAtIndex:selectedRow];
                EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                event.title     = calEvent.Title;
                
                event.startDate = calEvent.StartDate;
                event.endDate   = calEvent.EndDate;
                [event setNotes:calEvent.Description];
                //event.description = calEvent.description;
                
                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                NSError *err;
                [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                
               
                
            }else
            {
                //----- codes here when user NOT allow your app to access the calendar.
                
                
            }
            
            
        }];
        
    }
    [HUD hide:YES afterDelay:3];
    
}


- (BOOL)checkIsDeviceVersionHigherThanRequiredVersion:(NSString *)requiredVersion
{
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer compare:requiredVersion options:NSNumericSearch] != NSOrderedAscending)
    {
        return YES;
    }
    
    return NO;
}


@end
