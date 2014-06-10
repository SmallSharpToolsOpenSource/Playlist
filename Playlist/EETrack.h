//
//  EETrack.h
//  Playlist
//
//  Created by Brennan Stehling on 6/9/14.
//  Copyright (c) 2014 88nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EETrack : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *playDate;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) NSURL *imageURL;

@end
