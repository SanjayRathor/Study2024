//
//  ViewController.m
//  PreventScreenCaptureIniO
//
//  Created by Sanjay Singh Rathor on 29/09/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *note) {
        [self deleteMostRecentPhoto];
    }];
}
- (void)deleteMostRecentPhoto {
    NSMutableArray<PHAsset *> *assets = [NSMutableArray new];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *results = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    [results enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([object isKindOfClass:[PHAsset class]]) {
            [assets addObject:object];
        }
         *stop = YES;
    }];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:assets];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"Finished Delete asset. %@", (success ? @"Success." : error));
         if (success) {
            NSLog(@"delete successfully");
        }
    }];
    
    
    
//    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
//    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//
//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    for (PHAssetCollection *collection in smartAlbums) {
//        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
//         {
//            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
//
//
//
//            break;
//        }
//    }
//
    
}


@end
