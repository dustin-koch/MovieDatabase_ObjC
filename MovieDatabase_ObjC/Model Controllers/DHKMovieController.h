//
//  DHKMovieController.h
//  MovieDatabase_ObjC
//
//  Created by Dustin Koch on 5/24/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DHKMovie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHKMovieController : NSObject

//Singleton
+(instancetype) sharedInstance;

//CRUD (network calls)
- (void) fetchMoviesWithSearch:(NSString *)search completion:(void (^) (NSArray<DHKMovie *> *  movies)) completion;
- (void) fetchPosterForMovie:(DHKMovie *)movie completion:(void (^) (UIImage * _Nullable image))completion;

@end

NS_ASSUME_NONNULL_END
