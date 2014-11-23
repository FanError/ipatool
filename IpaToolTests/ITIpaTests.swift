//
//  ITIpaTests.swift
//  IpaTool
//
//  Created by Stefan on 07/10/14.
//  Copyright (c) 2014 Stefan van den Oord. All rights reserved.
//

import XCTest

class ITIpaTests_testConfig: XCTestCase {

    var config = ITTestConfig()
    var tempDirUrl:NSURL!
    
    override func setUp() {
        config.load()
        tempDirUrl = ITIpa.createTempDir()
    }
    
    override func tearDown() {
        var error:NSError?
        NSFileManager.defaultManager().removeItemAtURL(tempDirUrl, error: &error)
    }
    
    func testLoad()
    {
        let ipa = ITIpa()
        let (ok, error) = ipa.load("nonexisting.ipa")
        XCTAssertFalse(ok)
    }

    func testLoadTestConfig()
    {
        XCTAssertNotNil(config.ipaPath)
    }

    func testExtractIpa()
    {
        let ok = SSZipArchive.unzipFileAtPath(config.ipaFullPath!, toDestination: tempDirUrl?.path!)
        XCTAssertTrue(ok)
    }
    
}

class ITIpaTests: XCTestCase
{
    var config = ITTestConfig()
    var tempDirUrl:NSURL!
    var ipa:ITIpa!

    override func setUp() {
        config.load()
        tempDirUrl = ITIpa.createTempDir()

        ipa = ITIpa()
        let ipaPath = config.ipaPath
        let bundle = NSBundle(forClass: self.dynamicType)
        let ipaFullPath = bundle.pathForResource(ipaPath.stringByDeletingPathExtension, ofType:"ipa")
        let (ok, error) = ipa.load(ipaFullPath!)
        XCTAssertTrue(ok)
    }
    
    override func tearDown() {
        var error:NSError?
        NSFileManager.defaultManager().removeItemAtURL(tempDirUrl, error: &error)
    }

    func testAppName()
    {
        XCTAssertEqual(config.appName, ipa.appName)
    }
    
    func testDisplayName()
    {
        XCTAssertEqual(config.displayName, ipa.displayName)
    }
    
    func testBundleShortVersionString()
    {
        XCTAssertEqual(config.bundleShortVersionString, ipa.bundleShortVersionString)
    }
    
    func testBundleVersion()
    {
        XCTAssertEqual(config.bundleVersion, ipa.bundleVersion)
    }
    
    func testBundleIdentifier()
    {
        XCTAssertEqual(config.bundleIdentifier, ipa.bundleIdentifier)
    }
    
    func testMinimumOSVersion()
    {
        XCTAssertEqual(config.minimumOSVersion, ipa.minimumOSVersion)
    }
    
    func testReadProvisioningInformation()
    {
        let provisioningProfile = ipa.provisioningProfile!
        XCTAssertEqual(config.provisioningExpiration!, provisioningProfile.expirationDate()!)
        XCTAssertEqual(config.provisioningName, provisioningProfile.provisioningName()!)
        XCTAssertEqual(config.provisioningAppIdName, provisioningProfile.appIdName()!)
        XCTAssertEqual(config.provisioningTeam, provisioningProfile.teamName()!)
    }
    
    func testCodeSigningAuthority()
    {
        XCTAssertEqual(config.codeSigningAuthority, ipa.provisioningProfile!.codeSigningAuthority()!)
    }
}
