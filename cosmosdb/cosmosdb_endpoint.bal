//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
//

import ballerina/http;

# CosmosDB Client object.
# + cosmosDBConnector - CosmosDBConnector Connector object
public type Client client object {

    public CosmosDBConnector cosmosDBConnector;

    public function __init(CosmosDBConfiguration cosmosDBConfig) {
        self.cosmosDBConnector = new(cosmosDBConfig);
    }

    # Create a new database.
    #
    # + databaseId - Id of the database
    # + return - If success, returns DatabaseCreateResponse, else returns `error` object
    public remote function createDatabase(string databaseId, RequestOptions requestOptions)
                                returns DatabaseCreateResponse|error {
        return self.cosmosDBConnector->createDatabase(databaseId, requestOptions);
    }
};

# CosmosDB Connector configurations can be setup here.
# + baseURL - The base url of the Cosmos DB account
# + masterKey - The master key of your account
# + clientConfig - Client endpoint configurations provided by the user
public type CosmosDBConfiguration record {
    string baseURL;
    string masterKey;
    http:ClientEndpointConfig clientConfig = {};
};
