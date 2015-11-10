//
//  BombitaviInfo.h
//  Bombitavi
//
//  Created by Valeri Manchev on 10/16/15.
//  Copyright © 2015 Sami Kirkpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BombitaviInfo : NSObject

@property (strong, nonatomic) NSString *gameCode;
@property (strong, nonatomic) NSString *selectedGame;
@property (strong, nonatomic) NSString *player;

+ (id)sharedBombitaviInfo;

@end
