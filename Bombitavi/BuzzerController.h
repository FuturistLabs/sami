//
//  BuzzerController.h
//  Bombitavi
//
//  Created by Sami Kirkpatrick and Andrew Valner on 4/6/15.
//  Copyright (c) 2015 Sami Kirkpatrick and Andrew Valner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface BuzzerController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property NSString *name;
@property NSString *code;
@property BOOL *disable;



@end
