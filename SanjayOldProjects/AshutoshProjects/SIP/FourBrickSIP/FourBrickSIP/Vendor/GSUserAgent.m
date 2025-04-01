//
//  GSUserAgent.m
//  Gossip
//
//  Created by Chakrit Wichian on 7/5/12.
//

#import "GSUserAgent.h"
#import "GSUserAgent+Private.h"
#import "GSCodecInfo.h"
#import "GSCodecInfo+Private.h"
#import "GSDispatch.h"
#import "PJSIP.h"
#import "Util.h"


@implementation GSUserAgent {
    GSConfiguration *_configuration;
    pjsua_transport_id _transportId;
}

@synthesize account = _account;
@synthesize status = _status;

+ (GSUserAgent *)sharedAgent {
    static dispatch_once_t onceToken;
    static GSUserAgent *agent = nil;
    dispatch_once(&onceToken, ^{ agent = [[GSUserAgent alloc] init]; });
    
    return agent;
}


- (id)init {
    if (self = [super init]) {
        _account = nil;
        _configuration = nil;
        
        _transportId = PJSUA_INVALID_ID;
        _status = GSUserAgentStateUninitialized;
    }
    return self;
}

- (void)dealloc {
    if (_transportId != PJSUA_INVALID_ID) {
        pjsua_transport_close(_transportId, PJ_TRUE);
        _transportId = PJSUA_INVALID_ID;
    }
    
    if (_status >= GSUserAgentStateConfigured) {
        pjsua_destroy();
    }
    
    _account = nil;
    _configuration = nil;
    _status = GSUserAgentStateDestroyed;
}


- (GSConfiguration *)configuration {
    return _configuration;
}

- (GSUserAgentState)status {
    return _status;
}

- (void)setStatus:(GSUserAgentState)status {
    [self willChangeValueForKey:@"status"];
    _status = status;
    [self didChangeValueForKey:@"status"];
}


- (BOOL)configure:(GSConfiguration *)confige {
    GSAssert(!_configuration, @"Gossip: User agent is already configured.");
    _configuration = [confige copy];
    
    // create agent
    GSReturnNoIfFails(pjsua_create());
    [self setStatus:GSUserAgentStateCreated];
    
    pjsua_config config;
    pjsua_logging_config logging_config;
    pjsua_media_config media_config;
    pjsua_transport_config transport_config;
    
    pjsua_config_default(&config);
    [GSDispatch configureCallbacksForAgent:&config];
    
    pjsua_logging_config_default(&logging_config);
    pjsua_media_config_default(&media_config);
    pjsua_transport_config_default(&transport_config);
   // transport_config.port = 5060;

    media_config.has_ioqueue = PJ_TRUE;
    media_config.thread_cnt = 1;
    media_config.no_vad = PJ_TRUE;
    config.use_timer = PJSUA_SIP_TIMER_INACTIVE;
    config.max_calls = 30;
    GSReturnNoIfFails(pjsua_init(&config, &logging_config, &media_config));
    pjsua_transport_id transportIdentifier;
    GSReturnNoIfFails(pjsua_transport_create(PJSIP_TRANSPORT_UDP, &transport_config, &transportIdentifier));
    [self setStatus:GSUserAgentStateConfigured];
    
    GSReturnNoIfFails(pjsua_start());
    pjsua_set_no_snd_dev();
    
    // configure account
    _account = [[GSAccount alloc] init];
    return [_account configure:_configuration.account];
   
}


- (BOOL)start {
   // GSReturnNoIfFails(pjsua_start());
    [self setStatus:GSUserAgentStateStarted];
    return YES;
}

- (BOOL)reset {
    [_account disconnect];

    // needs to nil account before pjsua_destroy so pjsua_acc_del succeeds.
    _transportId = PJSUA_INVALID_ID;
    _account = nil;
    _configuration = nil;
    NSLog(@"Destroying...");
    GSReturnNoIfFails(pjsua_destroy());
    [self setStatus:GSUserAgentStateDestroyed];
    return YES;
}


- (NSArray *)arrayOfAvailableCodecs {
    GSAssert(!!_configuration, @"Gossip: User agent not configured.");
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    unsigned int count = 255;
    pjsua_codec_info codecs[count];
    GSReturnNilIfFails(pjsua_enum_codecs(codecs, &count));
    
    for (int i = 0; i < count; i++) {
        pjsua_codec_info pjCodec = codecs[i];
        
        GSCodecInfo *codec = [GSCodecInfo alloc];
        codec = [codec initWithCodecInfo:&pjCodec];
        [arr addObject:codec];
    }
    
    return [NSArray arrayWithArray:arr];
}

@end
