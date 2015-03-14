/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import XCTest

class LiveStorageClientTests : XCTestCase {
    // holygoat+permatest@gmail.com, password
    let ProdURI = NSURL(string: "https://sync-210-us-west-2.sync.services.mozilla.com/1.5/21288434/storage/meta/")
    
    func testLive() {
        let authorizer: Authorizer = {
            (r: NSMutableURLRequest) -> NSMutableURLRequest in
            return r
        }

        let factory: (String) -> CleartextPayloadJSON? = {
            (s: String) -> CleartextPayloadJSON? in
            return CleartextPayloadJSON(s)
        }

        let workQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let resultQueue = dispatch_get_main_queue()
        let meta = Sync15StorageClient(serverURI: ProdURI!, authorizer: authorizer, factory: factory, workQueue: workQueue, resultQueue: resultQueue)
        
        let expectation = expectationWithDescription("Waiting on value.")
        let deferred = meta.get("global")
        deferred.upon({ result in
            println("Here: \(result)")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { (error) in
            XCTAssertNil(error, "\(error)")
        }
        deferred.value
    }
}