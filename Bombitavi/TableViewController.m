//
//  TableViewController.m
//  Bombitavi
//
//  Created by Sami Kirkpatrick and Andrew Valner on 4/6/15.
//  Copyright (c) 2015 Sami Kirkpatrick and Andrew Valner. All rights reserved.
//

#import "EnterGameController.h"
#import "TableViewController.h"
#import "BuzzerController.h"
#import "BombitaviInfo.h"

@interface TableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tv;

@end

@implementation TableViewController
NSMutableArray *parseObjects;
//NSMutableArray *numbers;
//NSMutableArray *list;
NSTimer *timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = [[BombitaviInfo sharedBombitaviInfo] gameCode];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(refreshTable)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [timer invalidate];

    PFQuery *queryCode = [PFQuery queryWithClassName:@"code"];
    [queryCode whereKey:@"gameCode" equalTo:[[BombitaviInfo sharedBombitaviInfo] gameCode]];
    [queryCode findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                object[@"active"] = @NO;
                [object saveInBackground];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)refreshTable {    
    [self loadObjects];
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder: aDecoder];
    // This table displays items in the Todo class
    if (self) {
        
        self.parseClassName = @"buzzerInput";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
        
        parseObjects = [[NSMutableArray alloc]init];
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *queryCode = [PFQuery queryWithClassName:@"buzzerInput"];
    [queryCode whereKey:@"code" equalTo:_gameName];
    [queryCode findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                object[@"seen"] = @YES;
                [object saveInBackground];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"code" equalTo: _gameName];
    //NSLog(_gameName);
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
//    if (self.objects.count == 0) {
//        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *cellIdentifier = @"cell";
    
    [parseObjects addObject:object];
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    // Configure the cell to show todo item with a priority at the bottom
//    cell.textLabel.text = object[@"playerName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, object[@"playerName"]];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",
    // object[@"priority"]];
    
    return cell;
}

- (IBAction)refresh:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [timer invalidate];

            for (int i = 0; i < objects.count; i++) {
                PFObject *object = objects[i];
                
                if ( i == objects.count - 1 ) {
                    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [self refreshTable];
                        
                        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                 target:self
                                                               selector:@selector(refreshTable)
                                                               userInfo:nil
                                                                repeats:YES];
                    }];
                } else {
                    [object deleteInBackground];
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end


