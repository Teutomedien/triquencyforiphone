//
//  ProgrammViewController.h
//  triquencyforiphone
//
//  Created by Christoph Wolff on 26.07.12.
//  Copyright (c) 2012 Christoph Wolff. All rights reserved.
//



#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import <Foundation/NSJSONSerialization.h>
#import <UIKit/UIKit.h>
#import "GoogCal.h"
#import <EventKit/EventKit.h>
#import "MBProgressHUD.h"

@interface ProgrammViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIAlertViewDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;

    
    UIActionSheet *AddEventSheet;
    NSInteger selectedRow;
    NSMutableArray *_EventArray;

    
   
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingProgramm;
@property IBOutlet UITableView *myProgrammTable;
@property (nonatomic, strong) NSMutableArray *EventArray;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic,strong) NSOperationQueue *queue;

@property (nonatomic, strong) UIRefreshControl *refreshControl;


-(void)LoadCalendarData;
-(void)refreshControlTable;
-(void)AddEventToCalendar;
-(IBAction)cancel:(id)sender;
@end

