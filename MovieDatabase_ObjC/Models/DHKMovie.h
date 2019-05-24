//
//  DHKMovie.h
//  MovieDatabase_ObjC
//
//  Created by Dustin Koch on 5/24/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHKMovie : NSObject

@property (nonatomic, copy, readonly) NSString *movieTitle;
@property (nonatomic, copy, readonly, nullable) NSString *movieDescription;
@property (nonatomic, copy, readonly, nullable) NSString *posterPath;
@property (nonatomic, readonly, nullable) NSNumber *votes;
@property (nonatomic, copy, readonly, nullable) NSNumber *rating;

- (instancetype) initWithTitle:(NSString *)title movieDescription:(NSString *)movieDescription posterPath:(NSString *)posterPath votes:(NSNumber *)votes rating:(NSNumber *)rating;

@end

@interface DHKMovie (JSONConvertable)

- (instancetype) initWithDictionary:(NSDictionary<NSString *, id> *)dictionary;

@end

NS_ASSUME_NONNULL_END
