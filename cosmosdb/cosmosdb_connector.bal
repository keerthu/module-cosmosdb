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

import ballerina/http;

# Object to initialize the connection with CosmosDB.
#
# + masterKey - Master key.
# + cosmosDBClient - The HTTP Client
public type CosmosDBConnector client object {

    public string masterKey;
    public http:Client cosmosDBClient;

    public function __init(CosmosDBConfiguration cosmosDBConfig) {
        //self.cosmosDBClient = new(cosmosDBConfig.baseURL, config = cosmosDBConfig.clientConfig);
        self.cosmosDBClient = new(cosmosDBConfig.baseURL, config = cosmosDBConfig.clientConfig);
        self.masterKey = cosmosDBConfig.masterKey;
    }

    remote function createDatabase(string databaseId, RequestOptions requestOptions)
                                                    returns DatabaseCreateResponse|error;
};

remote function CosmosDBConnector.createDatabase(string databaseId, RequestOptions requestOptions)
                                                    returns DatabaseCreateResponse|error {
    http:Client httpClient = self.cosmosDBClient;
    string requestPath = DB_PATH;
    http:Request request = new;
    json spreadsheetJSONPayload = { "id": databaseId };
    request.setJsonPayload(spreadsheetJSONPayload);
    var requestHeaders = costructRequestHeaders(request, "post", "dbs", EMPTY_STRING, self.masterKey, JSON_CONTENT_TYPE
                                ,requestOptions);

    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        var httpResponse = httpClient->post(requestPath, request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:CREATED_201) {
                    ResourceResponse resourceResponse = {};
                    DatabaseCreateResponse databaseCreateResponse = {};
                    resourceResponse = extractResponseHeaders(httpResponse);
                    databaseCreateResponse = convertToDatabaseCreateResponse(jsonResponse);
                    databaseCreateResponse.resourceResponse = resourceResponse;
                    return databaseCreateResponse;
                } else {
                    return setResponseError(jsonResponse);
                }
            } else {
                error err = error(COSMOS_DB_ERROR_CODE,
                { message: "Error occurred while accessing the JSON payload of the response" });
                return err;
            }
        } else {
            error err = error(COSMOS_DB_ERROR_CODE, { message: "Error occurred while invoking the REST API" });
            return err;
        }
    }
}