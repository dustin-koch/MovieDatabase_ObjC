//
//  DHKMovieController.m
//  MovieDatabase_ObjC
//
//  Created by Dustin Koch on 5/24/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

#import "DHKMovieController.h"

//MARK: - Source of truth for URLs
static NSString * const baseUrlString = @"https://api.themoviedb.org/3/search/movie";
static NSString * const baseImageUrl = @"https://image.tmdb.org/t/p/w500";
static NSString * const query = @"query";
static NSString * const api = @"api_key";
static NSString * const apiKey = @"5ea295b9c220e17b10a8f5d6c5b866cb";

@implementation DHKMovieController

//MARK: - Singleton
+ (instancetype)sharedInstance
{
    static DHKMovieController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DHKMovieController new];
    });
    return sharedInstance;
}

//MARK: - CRUD (network fetch)
- (void)fetchMoviesWithSearch:(NSString *)search completion:(void (^)(NSArray<DHKMovie *> *))completion
{
    //construct URL
    NSURL *baseUrl = [NSURL URLWithString:baseUrlString];
    NSURLQueryItem *apiQuery = [[NSURLQueryItem alloc] initWithName:api value:apiKey];
    NSURLQueryItem *searchQuery = [[NSURLQueryItem alloc] initWithName:query value:search];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseUrl resolvingAgainstBaseURL:TRUE];
    components.queryItems = [[NSArray alloc] initWithObjects:(apiQuery), (searchQuery), nil];
    NSURL *finalUrl = components.URL;
    //testing URL construction
    NSLog(@"%@", [finalUrl absoluteString]);
    //datatask and completion
    [[[NSURLSession sharedSession] dataTaskWithURL:finalUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"There was an error in %s: %@, %@", __PRETTY_FUNCTION__, error, [error localizedDescription]);
            completion(nil);
            return;
        }
        if (data) {
            NSDictionary *jsonTopLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:2 error:&error];
            if (!jsonTopLevelDictionary) {
                NSLog(@"Error parsing json data top");
                completion(nil);
                return;
            }
            NSMutableArray *moviesArray = [NSMutableArray new];
            for (NSDictionary *movieDictionary in jsonTopLevelDictionary[@"results"]) {
                DHKMovie *movie = [[DHKMovie alloc] initWithDictionary:movieDictionary];
                [moviesArray addObject:movie];
            }
            completion(moviesArray);
        }
    }] resume];
}//END OF MOVIE FETCH

- (void)fetchPosterForMovie:(DHKMovie *)movie completion:(void (^)(UIImage * _Nullable))completion
{
    //build URL
    
    NSLog(@"%@", movie.posterPath);
    NSURL *baseUrl = [NSURL URLWithString:baseImageUrl];
    if ([movie.posterPath isKindOfClass:[NSNull class]]) {
        completion(nil);
        return;
    }
    NSURL *fullUrl = [baseUrl URLByAppendingPathComponent:movie.posterPath];
    //test print the constructed URL
    NSLog(@"%@", [fullUrl absoluteString]);
    //data fetch and completion
    [[[NSURLSession sharedSession] dataTaskWithURL:fullUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(nil);
            return;
        }
        
        
        UIImage *movieImage = [UIImage imageWithData:data];
        completion(movieImage);
    }] resume];
}//END OF image fetch

@end
