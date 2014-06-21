//
//  EEViewController.m
//  Playlist
//
//  Created by Brennan Stehling on 6/9/14.
//  Copyright (c) 2014 88nine. All rights reserved.
//

#import "EEViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "EETrack.h"

#import "UIImageView+AFNetworking.h"
#import "NSString+HTML.h"

#define kBaseURL @"http://www.radiomilwaukee.org"
#define kPlaylistURL @"/playlist-api?raw=1"

// http://www.radiomilwaukee.org/playlist-api?raw=1

@interface EEViewController ()

@property (nonatomic, strong) NSArray *tracks;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EEViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadPlaylist];
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)reloadButtonTapped:(id)sender {
    [self loadPlaylist];
}

#pragma mark - Private
#pragma mark -

- (void)loadPlaylist {
    NSLog(@"Loading playlist");
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json charset=utf-8", @"application/json"]];
    
    AFHTTPRequestOperation *requestOperation = [manager GET:kPlaylistURL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *dictionary) {
        //NSLog(@"playlist: %@", dictionary);
        
        NSMutableArray *tracks = @[].mutableCopy;
        
        NSArray *nodes = dictionary[@"nodes"];
        for (NSDictionary *item in nodes) {
            NSDictionary *node = item[@"node"];
            EETrack *track = [[EETrack alloc] init];
            
            track.title = [node[@"title"] stringByDecodingHTMLEntities];
            track.body = [node[@"body"] stringByDecodingHTMLEntities];
            track.path = node[@"path"];
            track.playDate = node[@"play_date"];
            track.artist = [node[@"field_artist"] stringByDecodingHTMLEntities];
            track.album = [node[@"body"] stringByDecodingHTMLEntities];
            if (node[@"field_image"]) {
                track.imageURL= [NSURL URLWithString:node[@"field_image"]];
            }
            
            [tracks addObject:track];
        }
        
        self.tracks = tracks;
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.description);
    }];
    [requestOperation start];
}

- (void)addToMutableArray:(NSMutableArray *)mutableArray {
    if (!mutableArray) {
        mutableArray = @[].mutableCopy;
    }
    [mutableArray addObject:mutableArray];
    [self addToMutableArray:mutableArray];
}

#pragma mark - UITableViewDataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TrackCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    EETrack *track = self.tracks[indexPath.row];
    cell.textLabel.text = track.title;
    if (track.album.length && track.artist.length) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", track.album, track.artist];
    }
    else if (track.album.length) {
        cell.detailTextLabel.text = track.album;
    }
    else if (track.artist.length) {
        cell.detailTextLabel.text = track.artist;
    }
    else {
        cell.detailTextLabel.text = nil;
    }
    
    if (track.imageURL) {
        [cell.imageView setImageWithURL:track.imageURL];
    }
    else {
        cell.imageView.image = nil;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    });
}

@end
