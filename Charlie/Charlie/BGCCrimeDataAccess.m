//
//  BGCCrimeDataAccess.m
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import "BGCCrimeDataAccess.h"

@implementation BGCCrimeDataAccess

#pragma mark - definitions

static NSString * kRequestURL = @"http://nameless-beyond-9906.herokuapp.com/beat/2525";

#pragma mark - Easy Get Request
- (id) myGetRequest: (NSURL *) url{
    
    NSArray *json = [[NSArray alloc] init];
    
    NSError * dataGrabbingError;
    
    NSData* data = [NSData dataWithContentsOfURL:
                    url options: NSDataReadingUncached error:&dataGrabbingError];
    
    if (dataGrabbingError){
        [self performSelector:@selector(errorGrabbingData:) onThread:[NSThread mainThread] withObject:dataGrabbingError waitUntilDone:NO];
        return nil;
    }
    
    NSError *error;
    
    if (data)
        json = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:&error];
    
    return json;
}


-(void) fillCrimeDataFromServerASynchrously{
    
    
}



@end
