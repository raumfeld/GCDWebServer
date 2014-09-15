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

typedef NSData* (^GCDWebServerPreDataBlock)       (GCDWebServerDataBlockResponseState *stateObject, NSMutableDictionary *additionalHeaders);
typedef NSData* (^GCDWebServerFetchDataBlock)     (GCDWebServerDataBlockResponseState *stateObject, NSInteger maxLength);
typedef NSData* (^GCDWebServerPostDataBlock)      (GCDWebServerDataBlockResponseState *stateObject);

@interface GCDWebServerDataBlockResponse : GCDWebServerResponse {
@private
    NSInteger _offset;
    GCDWebServerPreDataBlock   _dataPreBlock;   // prepare block is called before fetch block
    GCDWebServerFetchDataBlock _dataFetchBlock; // fetch block, is called until no more data is available
    GCDWebServerPostDataBlock  _dataPostBlock;  // is called after fetch block returns no more data
    GCDWebServerDataBlockResponseState* _dataBlockState; // state holder that is used between calls of _data*Block
}
- (id)initWithContentType:(NSString*)type
                 preBlock:(GCDWebServerPreDataBlock) preBlock
               fetchBlock:(GCDWebServerFetchDataBlock) fetchBlock
                postBlock:(GCDWebServerPostDataBlock) postBlock;

@end

