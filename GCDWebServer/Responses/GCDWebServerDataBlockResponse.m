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
                 preBlock:(GCDWebServerDataBlock) preBlock
               fetchBlock:(GCDWebServerDataBlock) fetchBlock
                postBlock:(GCDWebServerDataBlock) postBlock {
    if ((self = [super init])) {
        DCHECK(preBlock);
        DCHECK(fetchBlock);
        DCHECK(postBlock);
        _dataPreBlock   = [preBlock copy];
        _dataFetchBlock = [fetchBlock copy];
        _dataPostBlock  = [postBlock copy];
    }
    return self;
}

- (BOOL)open {
    _dataBlockState = [GCDWebServerDataBlockResponseState new];
    _dataPreBlock(_dataBlockState, 0);
    
    return YES;
}

- (NSInteger)read:(void*)buffer maxLength:(NSUInteger)length {
    DCHECK(_offset >= 0);
    NSInteger size = 0;
    
    NSData *nextChunk = _dataFetchBlock(_dataBlockState, length);
    if (!nextChunk)
        return 0;
    
    size = nextChunk.length;
    DCHECK(size <= length);
    bcopy((char*)nextChunk.bytes, buffer, size);
    _offset += size;
    
    return size;
}

- (void)close {
    _dataPostBlock(_dataBlockState, 0);
}

@end

