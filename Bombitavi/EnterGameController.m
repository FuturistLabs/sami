//
//  EnterGameController.m
//  Bombitavi
//
//  Created by Sami Kirkpatrick and Andrew Valner on 4/6/15.
//  Copyright (c) 2015 Sami Kirkpatrick and Andrew Valner. All rights reserved.
//

#import "EnterGameController.h"
#import "TableViewController.h"
#import "BombitaviInfo.h"

@interface EnterGameController ()

@property (weak, nonatomic) IBOutlet UITextField *gameCode;

@end

@implementation EnterGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startGame:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"code"];
    [query whereKey:@"gameCode" equalTo:self.gameCode.text];
    [query whereKey:@"active" equalTo:@YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            if ( objects.count == 0 ) {
                [[BombitaviInfo sharedBombitaviInfo] setGameCode:self.gameCode.text];
                
                PFObject *code = [PFObject objectWithClassName:@"code"];
                code [@"gameCode"] = self.gameCode.text;
                code [@"active"] = @YES;
                [code saveInBackground];
                
                [self performSegueWithIdentifier:@"startGame" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[NSString stringWithFormat:@"%@ code already exist!", self.gameCode.text]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [self.gameCode resignFirstResponder];
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     
TableViewController *vc = [segue destinationViewController];
//Pass the selected object to the new view controller.
 vc.gameName = self.gameCode.text;
 }

@end
