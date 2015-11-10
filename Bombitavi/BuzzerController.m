//
//  BuzzerController.m
//  Bombitavi
//
//  Created by Sami Kirkpatrick and Andrew Valner on 4/6/15.
//  Copyright (c) 2015 Sami Kirkpatrick and Andrew Valner. All rights reserved.
//
#import "TableViewController2.h"
#import "BuzzerController.h"
#import "CreateGameController.h"
#import "BombitaviInfo.h"

#import <AudioToolbox/AudioToolbox.h>

#include "TargetConditionals.h"

@interface BuzzerController ()

@end

@implementation BuzzerController


- (void)viewDidLoad {
    [super viewDidLoad];
    _playerName.text = [[BombitaviInfo sharedBombitaviInfo] player];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playAudio {
    [self playSound:@"Buzzer" :@"mp3"];
}

- (void)playSound :(NSString *)fName :(NSString *) ext {
    SystemSoundID audioEffect;
    NSString *path = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else {
        NSLog(@"error, file not found: %@", path);
    }
}

- (IBAction)buzzer:(id)sender {
    PFQuery *queryCode = [PFQuery queryWithClassName:@"buzzerInput"];
    [queryCode whereKey:@"code" equalTo:[[BombitaviInfo sharedBombitaviInfo] selectedGame]];
    [queryCode whereKey:@"playerName" equalTo:self.playerName.text];
    [queryCode whereKey:@"seen" equalTo:@NO];
    [queryCode findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            if ( objects.count == 0 ) {
                if(_disable == NO ){
                    PFObject *buzzerInput = [PFObject objectWithClassName:@"buzzerInput"];
                    buzzerInput [@"playerName"] = self.playerName.text;
                    buzzerInput [@"code"] = [[BombitaviInfo sharedBombitaviInfo] selectedGame];
                    buzzerInput [@"seen"] = @NO;
                    [buzzerInput saveInBackground];
                    
                    [self playAudio];
                    
                    if (!TARGET_IPHONE_SIMULATOR) {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    }
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"You have already buzz! Wait until the host refreshes the page."
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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
