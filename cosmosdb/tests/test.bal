// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/config;
import ballerina/io;
import ballerina/test;
import ballerina/log;
import ballerina/http;

CosmosDBConfiguration cosmosDBConfig = {
    baseURL: config:getAsString("BASE_URL"),
    masterKey: config:getAsString("MASTER_KEY")
};

Client cosmosdbClient = new(cosmosDBConfig);


@test:Config
function testCreateDatabase() {
    io:println("-----------------Test case for createDatabase method------------------");
    RequestOptions requestOptions = {};
    var dbRes = cosmosdbClient->createDatabase("testBaldb", requestOptions);
    if (dbRes is DatabaseCreateResponse) {
        test:assertNotEquals(dbRes.id, null, msg = "Failed to create database");
    } else {
        test:assertFail(msg = <string>dbRes.detail().message);
    }
}
