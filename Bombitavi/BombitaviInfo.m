//
//  BombitaviInfo.m
//  Bombitavi
//
//  Created by Valeri Manchev on 10/16/15.
//  Copyright © 2015 Sami Kirkpatrick. All rights reserved.
//

#import "BombitaviInfo.h"

@implementation BombitaviInfo

+ (id)sharedBombitaviInfo {
    static BombitaviInfo *sharedBombitaviInfo = nil;
    
    @synchronized(self) {
        if ( sharedBombitaviInfo == nil )
            sharedBombitaviInfo = [[self alloc] init];
    }
    
    return sharedBombitaviInfo;
}

@end
