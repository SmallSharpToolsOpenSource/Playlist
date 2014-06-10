//
//  EEViewController.m
//  Playlist
//
//  Created by Brennan Stehling on 6/9/14.
//  Copyright (c) 2014 88nine. All rights reserved.
//

#import "EEViewController.h"

#import "AFHTTPRequestOperationManager.h"

#define kBaseURL @"http://www.radiomilwaukee.org"
#define kPlaylistURL @"/playlist-api?raw=1"

// http://www.radiomilwaukee.org/playlist-api?raw=1

@interface EEViewController ()

@property (nonatomic, strong) NSArray *tracks;

@end

@implementation EEViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadPlaylist];
}

#pragma mark - Private
#pragma mark -

- (void)loadPlaylist {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSLog(@"acceptableContentTypes: %@", manager.responseSerializer.acceptableContentTypes);
    
    AFHTTPRequestOperation *requestOperation = [manager GET:kPlaylistURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"playlist: %@ (%@)", responseObject, NSStringFromClass(responseObject));
        
//        NSError *error;
//        NSArray *json = [NSJSONSerialization
//                         JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
//                         options:kNilOptions
//                         error:&error];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.description);
    }];
    [requestOperation start];
}


#pragma mark - UITableViewDataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TrackCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}



@end
