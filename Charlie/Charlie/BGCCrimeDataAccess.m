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

-(NSDictionary *) grabJSONTestData{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];

    NSData * data = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary * json;
    NSError * error;
    
    if (data)
        json = [NSJSONSerialization
                JSONObjectWithData:data
                options:kNilOptions
                error:&error];
    
    return json;
}


-(void) fillCrimeDataFromServerASynchrously{
    
    NSDictionary * sampleData = [self grabJSONTestData];
    NSMutableArray * mutableCrimeData = [[NSMutableArray alloc] init];
    
    for (NSString * key in sampleData){
        
        NSMutableArray * crimeObjectArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary * crime in sampleData[key]){
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake( ((NSString*)crime[@"Latitude"]).doubleValue, ((NSString *)crime[@"Longitude"]).doubleValue);
            BGCCrimeObject * crimeObject = [[BGCCrimeObject alloc] initWithProbability: ((NSString *)crime[@"Probability"]).doubleValue time:key.integerValue andCoordinate:coordinate];
            [crimeObjectArray addObject:crimeObject];
            
        }
        
        [mutableCrimeData addObject:crimeObjectArray];
        
    }
    
    self.crimeData = [mutableCrimeData copy];
    
    NSLog(@"crime data %@", self.crimeData);
    
}

#pragma mark - lazy instantiation

-(NSArray *) crimeData{
    
    if (!_crimeData){
        _crimeData = [[NSArray alloc] init];
    }
    
    return _crimeData;
}



@end
