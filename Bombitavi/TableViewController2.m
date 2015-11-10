//
//  TableViewController2.m
//  Bombitavi
//
//  Created by Sami Kirkpatrick on 4/23/15.
//  Copyright (c) 2015 Sami Kirkpatrick. All rights reserved.
//

#import "BuzzerController.h"
#import "TableViewController2.h"
#import "CreateGameController.h"
#import "EnterGameController.h"
#import "BombitaviInfo.h"

@interface TableViewController2 ()

@end

@implementation TableViewController2
NSMutableArray *parseObjects;

- (void)viewDidAppear:(BOOL)animated {
    [self loadObjects];
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder: aDecoder];
    // This table displays items in the Todo class
    if (self) {
        
        //self.parseClassName = @"buzzerInput";
        self.parseClassName = @"code";
        //self.parseClassName = @"code";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
        
        parseObjects = [[NSMutableArray alloc]init];
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    
    [query orderByDescending:@"createdAt"];
   
    [query whereKey:@"active" equalTo:@YES];

    query.limit = 4;
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }


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
    cell.textLabel.text = object[@"gameCode"];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",
    // object[@"priority"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nameTVC = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    
    [[BombitaviInfo sharedBombitaviInfo] setSelectedGame:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BuzzerController *vc = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    vc.name = self.nameTVC;
}



@end
