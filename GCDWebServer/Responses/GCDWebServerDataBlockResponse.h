//
//  GCDWebServerDataBlockResponse.h
//  RaumfeldControl
//
//  Created by Sebastian on 12/09/14.
//  Copyright (c) 2014 Raumfeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDWebServerResponse.h"

@interface GCDWebServerDataBlockResponseState : NSObject
@property (nonatomic) NSError *error;
@property (nonatomic, retain) id customData;
@end

typedef NSData* (^GCDWebServerDataBlock)     (GCDWebServerDataBlockResponseState *stateObject, NSInteger maxLength);

@interface GCDWebServerDataBlockResponse : GCDWebServerResponse {
@private
    NSInteger _offset;
    GCDWebServerDataBlock _dataPreBlock;   // prepare block is called before fetch block
    GCDWebServerDataBlock _dataFetchBlock; // fetch block, is called until no more data is available
    GCDWebServerDataBlock _dataPostBlock;  // is called after fetch block returns no more data
    GCDWebServerDataBlockResponseState* _dataBlockState; // state holder that is used between calls of _data*Block
}
- (id)initWithContentType:(NSString*)type
                 preBlock:(GCDWebServerDataBlock) preBlock
               fetchBlock:(GCDWebServerDataBlock) fetchBlock
                postBlock:(GCDWebServerDataBlock) postBlock;
@end

