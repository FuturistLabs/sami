//
//  CreateGameController.m
//  Bombitavi
//
//  Created by Sami Kirkpatrick and Andrew Valner on 4/6/15.
//  Copyright (c) 2015 Sami Kirkpatrick and Andrew Valner. All rights reserved.
//

#import "CreateGameController.h"
#import "TableViewController2.h"
#import "BombitaviInfo.h"

@interface CreateGameController ()

@property (weak, nonatomic) IBOutlet UITextField *enterPlayerName;

@end

@implementation CreateGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendToParse{
    PFObject *currentPlayers = [PFObject objectWithClassName:@"CurrentPlayers"];
    currentPlayers[@"name"] = self.enterPlayerName.text;
    [currentPlayers saveInBackground];
    
    [self.enterPlayerName resignFirstResponder];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self sendToParse];
    TableViewController2 *vc = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    vc.nameTVC = self.enterPlayerName.text;
    [[BombitaviInfo sharedBombitaviInfo] setPlayer:self.enterPlayerName.text];
}


@end
