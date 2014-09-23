//
//  GCDWebServerDataBlockResponse.m
//  RaumfeldControl
//
//  Created by Sebastian on 12/09/14.
//  Copyright (c) 2014 Raumfeld. All rights reserved.
//

#import "GCDWebServerDataBlockResponse.h"
#import "GCDWebServerPrivate.h"
#import "GCDWebServerResponse.h"

@implementation GCDWebServerDataBlockResponseState
@end

@implementation GCDWebServerDataBlockResponse

- (id)initWithContentType:(NSString*)type
                 preBlock:(GCDWebServerPreDataBlock) preBlock
               fetchBlock:(GCDWebServerFetchDataBlock) fetchBlock
                postBlock:(GCDWebServerPostDataBlock) postBlock {
    if ((self = [super init])) {
        DCHECK(preBlock);
        DCHECK(fetchBlock);
        DCHECK(postBlock);
        
        self.contentType = type;
        _dataPreBlock   = [preBlock copy];
        _dataFetchBlock = [fetchBlock copy];
        _dataPostBlock  = [postBlock copy];
    }
    return self;
}

- (BOOL)open:(NSError**)error {
    __block NSMutableDictionary *additionalHeaders = [NSMutableDictionary new];
    _dataBlockState = [GCDWebServerDataBlockResponseState new];
    _dataPreBlock(_dataBlockState, additionalHeaders);
    [additionalHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forAdditionalHeader:key];
    }];
    
    return nil == _dataBlockState.error;
}

- (NSData*)readData:(NSError**)error {
    DCHECK(_offset >= 0);
    NSUInteger size = 0;
    NSUInteger length = NSUIntegerMax;
    
    NSData *nextChunk = _dataFetchBlock(_dataBlockState, length);
    if (!nextChunk || _dataBlockState.error)
        return 0;
    
    size = nextChunk.length;
    DCHECK(size <= length);
    _offset += size;
    
    return nextChunk;
}


- (void)close {
    _dataPostBlock(_dataBlockState);
}

@end

