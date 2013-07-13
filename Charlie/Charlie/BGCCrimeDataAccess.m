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

static NSString * kRequestURL = @"http://tranquil-anchorage-3678.herokuapp.com/beat/";

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


-(void) fillCrimeDataFromServerASynchrouslyForBeat:(NSInteger)beat{
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("Grab Beat Data", NULL);
    dispatch_async(downloadQueue, ^{
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%i", kRequestURL, beat]];
        NSDictionary * data = [self myGetRequest:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray * mutableCrimeData = [[NSMutableArray alloc] init];
            
            for (NSString * key in data){
                
                NSMutableArray * crimeObjectArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary * crime in data[key]){
                    
                    
                    CLLocation * location = [[CLLocation alloc] initWithLatitude:((NSString*)crime[@"Latitude"]).doubleValue longitude:((NSString *)crime[@"Longitude"]).doubleValue];
                    BGCCrimeObject * crimeObject = [[BGCCrimeObject alloc] initWithProbability: ((NSString *)crime[@"Probability"]).doubleValue time:key.integerValue andLocation:location];
                    [crimeObjectArray addObject:crimeObject];
                    
                }
                
                [mutableCrimeData addObject:crimeObjectArray];
                
            }
            
            self.crimeData = [mutableCrimeData copy];
            
            [self.delegate crimeDataFillComplete:self.crimeData];
            
        });
    });
    
    
}

#pragma mark - testing methods

-(void) fillSampleCrimeData{
    NSDictionary * sampleData = [self grabJSONTestData];
    NSMutableArray * mutableCrimeData = [[NSMutableArray alloc] init];
    
    for (NSString * key in sampleData){
        
        NSMutableArray * crimeObjectArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary * crime in sampleData[key]){
            
            
            CLLocation * location = [[CLLocation alloc] initWithLatitude:((NSString*)crime[@"Latitude"]).doubleValue longitude:((NSString *)crime[@"Longitude"]).doubleValue];
            BGCCrimeObject * crimeObject = [[BGCCrimeObject alloc] initWithProbability: ((NSString *)crime[@"Probability"]).doubleValue time:key.integerValue andLocation:location];
            [crimeObjectArray addObject:crimeObject];
            
            
            
        }
        
        [mutableCrimeData addObject:crimeObjectArray];
        
    }
    
    self.crimeData = [mutableCrimeData copy];
    
    [self.delegate crimeDataFillComplete:self.crimeData];
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

#pragma mark - class calls

-(void) errorGrabbingData: (NSError *) error{
    
}

#pragma mark - lazy instantiation

-(NSArray *) crimeData{
    
    if (!_crimeData){
        _crimeData = [[NSArray alloc] init];
    }
    
    return _crimeData;
}



@end
