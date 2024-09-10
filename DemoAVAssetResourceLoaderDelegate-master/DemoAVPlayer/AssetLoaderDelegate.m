
#import "AssetLoaderDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSURL+CustomScheme.h"
#import "SCTE35AdsData.h"

#define kMultiVarianTag                      @"#EXT-X-STREAM-INF"
NSString * const SlikeScte35Notification =   @"SlikeScte35Notification";
NSString * const kScte35InfoKey          =   @"kScte35InfoKey";

@interface AssetLoaderDelegate ()
@end

@implementation AssetLoaderDelegate

- (instancetype)init {
    if (self = [super init]) { }
    return self;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    if (!loadingRequest.request.URL.scheme || !loadingRequest.dataRequest) {
        return false;
    }
    
    NSURL *loadingURL = loadingRequest.request.URL;
    if ([loadingRequest.request.URL.scheme isEqualToString:SLPlaylistScheme]) {
        
        NSURL *newURL = [loadingURL replaceURLWithScheme:SLHttpScheme];
        return [self downloadM3U8:newURL handler:^(NSData *aData, NSError *error) {
            if (error) {
                [loadingRequest finishLoadingWithError:error];
                return;
            }
            
            NSString *string = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
            if(!string) {
                [loadingRequest redirectToServer];
                return;
            }
            
            NSData *playlistData = nil;
            if ([string containsString:kMultiVarianTag]) {
                NSString* mainM3U8 =  [self parseMainMultiVariantPlaylist:string baseURL:newURL];
                if ([mainM3U8 isEqualToString:@""]) {
                    [loadingRequest redirectToServer];
                    return;
                }
                NSLog(@"%@", mainM3U8);
                playlistData = [mainM3U8 dataUsingEncoding:NSUTF8StringEncoding];
                
            } else {
                NSString* m3u8 = [self buildMainPlaylist:string baseURL:newURL];
                if ([m3u8 isEqualToString:@""]) {
                    [loadingRequest redirectToServer];
                    return;
                }
                NSLog(@"%@", m3u8);
                playlistData = [m3u8 dataUsingEncoding:NSUTF8StringEncoding];
            }
            
            [loadingRequest contentInformationRequest].contentType = @"public.m3u-playlist";
            [loadingRequest contentInformationRequest].contentLength = aData.length;
            [[loadingRequest contentInformationRequest] setByteRangeAccessSupported:TRUE];
            
            [loadingRequest.dataRequest respondWithData:playlistData];
            [loadingRequest finishLoading];
        }];
        
    } else if ([loadingRequest.request.URL.scheme isEqualToString:SLSegmentScheme]) {
        [loadingRequest redirectToServer];
    }
    else {
        [loadingRequest redirectToServer];
    }
    
    return TRUE;
}

/// Parse  MultiVariant Playlist
/// - Parameters:
///   - aString: Contents
///   - aBaseURL: Media Main URL
- (NSString *)parseMainMultiVariantPlaylist:(NSString *)aString baseURL:(NSURL *)aBaseURL {
    
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *lines = [aString componentsSeparatedByCharactersInSet:separator];
    NSMutableArray *playlistArray = [[NSMutableArray alloc] init];
    
    NSInteger lineIndex = 0;
    while (lineIndex < [lines count]) {
        NSString *line = [lines objectAtIndex:lineIndex];
        if ([line  isEqualToString: @""]) {
            lineIndex++;
            continue;
        }
        NSArray *allowedPathExtensions = @[@"m3u8"];
        if ([allowedPathExtensions containsObject:line.pathExtension]) {
            NSURL *streamURL = [self absoluteURLFromLine:line forOriginURL:aBaseURL scheme:SLPlaylistScheme];
            if(streamURL) {
                [playlistArray addObject:streamURL.absoluteString];
            }
        } else {
            [playlistArray addObject:line];
        }
        
        lineIndex++;
    }
    return [playlistArray componentsJoinedByString:@"\n"];
}

/// Parse  Main  Playlist
/// - Parameters:
///   - aString: Contents
///   - aBaseURL: Media Main URL
///
- (NSString *)buildMainPlaylist:(NSString *)aString baseURL:(NSURL *)aBaseURL {
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSArray *lines = [aString componentsSeparatedByCharactersInSet:separator];
    NSMutableArray *playlistArray = [[NSMutableArray alloc] init];
    
    NSInteger lineIndex = 0;
    while (lineIndex < [lines count]) {
        NSString *line = [lines objectAtIndex:lineIndex];
        if ([line  isEqualToString: @""]) {
            lineIndex++;
            continue;
        }
        NSArray *allowedPathExtensions = @[@"ts"];
        if ([allowedPathExtensions containsObject:line.pathExtension]) {
            NSURL *streamURL = [self absoluteURLFromLine:line forOriginURL:aBaseURL scheme:SLSegmentScheme];
            if(streamURL) {
                [playlistArray addObject:streamURL.absoluteString];
            }
        } else {
            [playlistArray addObject:line];
        }
        
        [self scte35Parser:line];
        
        lineIndex++;
    }
    
    return [playlistArray componentsJoinedByString:@"\n"];
}

/// Downalod
/// - Parameters:
///   - aURL: M3U8 Url
///   - completionBlock: Completion Block
- (BOOL)downloadM3U8:(NSURL *)aURL handler:(void(^)(NSData *aData, NSError * error))completionBlock {
    
    NSURLSessionTask * task =  [[NSURLSession sharedSession] dataTaskWithURL:aURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            completionBlock(NULL, error);
            return;
        }
        completionBlock(data, NULL);
    }];
    task.priority = 1.0;
    [task resume];
    return TRUE;
}

/// Relative URL
/// - Parameters:
///   - line: playlist line
///   - originURL: Media URL
///   - aNewScheme: Scheme
- (NSURL *)absoluteURLFromLine:(NSString *)line forOriginURL:(NSURL *)originURL scheme:(NSString *)aNewScheme {
    
    if ([line hasPrefix:@"http://"] || [line hasPrefix:@"https://"]) {
        return [NSURL URLWithString:line];
    }
    
    NSString *scheme = originURL.scheme;
    NSString *host = originURL.host;
    if (!scheme || !host) {
        return nil;
    }
    
    NSString *path;
    if ([line hasPrefix:@"/"]) {
        path = line;
    } else {
        path = [[[originURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:line] path];
    }
    
    NSString *absoluteString = [NSString stringWithFormat:@"%@://%@%@", scheme, host, path];
    NSURL *url = [NSURL URLWithString:absoluteString];
    NSURL *standardizedURL =  [url standardizedURL];
    return [standardizedURL replaceURLWithScheme:aNewScheme];
}

- (void)scte35Parser:(NSString *)aLine {
    
    if ([aLine hasPrefix:@"#EXT-X-OATCLS-SCTE35:"]) {
        NSArray *components = [aLine componentsSeparatedByString:@"="];
        if (components.count > 1) {
            SCTE35AdsData *adsMarker = [[SCTE35AdsData alloc]init];
            NSString *messageString = components[1];
            adsMarker.cueMessage = messageString;
            adsMarker.cueType = willStart;
            [[NSNotificationCenter defaultCenter] postNotificationName:SlikeScte35Notification object:nil userInfo:@{
                kScte35InfoKey:adsMarker
            }];
        }
    } else if ([aLine hasPrefix:@"#EXT-X-CUE-OUT:"]) {
        NSArray *components = [aLine componentsSeparatedByString:@":"];
        if (components.count > 1) {
            SCTE35AdsData *adsMarker = [[SCTE35AdsData alloc]init];
            NSString *durationString = components[1];
            float duration = [durationString floatValue];
            adsMarker.time = duration;
            adsMarker.cueType = didStarted;
            [[NSNotificationCenter defaultCenter] postNotificationName:SlikeScte35Notification object:nil userInfo:@{
                kScte35InfoKey:adsMarker
            }];
        }
        
    } else if ([aLine hasPrefix:@"#EXT-X-CUE-IN"]) {
        SCTE35AdsData *adsMarker = [[SCTE35AdsData alloc]init];
        adsMarker.cueType = ended;
        [[NSNotificationCenter defaultCenter] postNotificationName:SlikeScte35Notification object:nil userInfo:@{
            kScte35InfoKey:adsMarker
        }];
        
    } else if ([aLine hasPrefix:@"#EXT-X-CUE-OUT-CONT:"]) {
        
        SCTE35AdsData *adsMarker = [[SCTE35AdsData alloc]init];
        adsMarker.cueType = inContinue;
        NSScanner *scanner = [NSScanner scannerWithString:aLine];
        NSString *elapsedTime, *duration, *scte35;
        [scanner scanUpToString:@"ElapsedTime=" intoString:nil];
        [scanner scanString:@"ElapsedTime=" intoString:nil];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","] intoString:&elapsedTime];
        
        [scanner scanUpToString:@"Duration=" intoString:nil];
        [scanner scanString:@"Duration=" intoString:nil];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","] intoString:&duration];
        
        [scanner scanUpToString:@"SCTE35=" intoString:nil];
        [scanner scanString:@"SCTE35=" intoString:nil];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&scte35];
        
        adsMarker.elapsed = [elapsedTime floatValue];
        adsMarker.time = [duration floatValue];
        adsMarker.cueMessage = scte35;
        [[NSNotificationCenter defaultCenter] postNotificationName:SlikeScte35Notification object:nil userInfo:@{
            kScte35InfoKey:adsMarker
        }];
    }
    else if ([aLine hasPrefix:@"#EXT-X-PROGRAM-DATE-TIME:"]) {
        NSArray *components = [aLine componentsSeparatedByString:@":"];
        if (components.count > 1) {
            NSString *ptimeString = components[1];
            NSLog(@"PRGRAM TIME = %@", ptimeString);
            SCTE35AdsData *adsMarker = [[SCTE35AdsData alloc]init];
            NSLog(@"PRGRAM DATE = %@",  [adsMarker programTime:ptimeString]);
        }
    }
    
}

@end

@implementation AVAssetResourceLoadingRequest(Redirect)

- (BOOL)redirectToServer {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableURLRequest *redirect = nil;
        NSURL *requestURL = self.request.URL;
        requestURL = [requestURL replaceURLWithScheme:SLHttpScheme];
        redirect = [NSMutableURLRequest requestWithURL:requestURL];
        
        if (redirect) {
            redirect.HTTPMethod = @"GET";
            redirect.allHTTPHeaderFields = self.request.allHTTPHeaderFields;
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[redirect URL] statusCode:302 HTTPVersion:nil headerFields:self.request.allHTTPHeaderFields];
            [self setResponse:response];
            [self setRedirect:redirect];
            [self finishLoading];
            
            ///NSLog(@"Redirect:::%@\n\n", [redirect URL]);
            
        } else {
            [self finishLoadingWithError:[NSError errorWithDomain: NSURLErrorDomain code:400 userInfo: nil]];
        }
    });
    return TRUE;
}
@end
