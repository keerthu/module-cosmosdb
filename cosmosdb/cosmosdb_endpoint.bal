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
# + masterKey - Master key.
# + documentClient - The HTTP Client.
public type Client client object {

    public string masterKey;
    public http:Client documentClient;

    public function __init(CosmosDBConfiguration cosmosDBConfig) {
        self.documentClient = new(cosmosDBConfig.baseURL, config = cosmosDBConfig.clientConfig);
        self.masterKey = cosmosDBConfig.masterKey;
    }

    # List databases.
    #
    # + requestOptions - Optional header properties
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function listDatabases(RequestOptions? requestOptions = ())
                               returns DatabaseListResponse|error;

    # Create a new database.
    #
    # + databaseId - Id of the database
    # + requestOptions - Optional header properties
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function createDatabase(string databaseId, RequestOptions? requestOptions = ())
                               returns DatabaseResponse|error;

    # Get a  database.
    #
    # + databaseId - Id of the database
    # + requestOptions - Optional header properties
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function getDatabase(string databaseId, RequestOptions? requestOptions = ())
                               returns DatabaseResponse|error;

    # Delete a  database.
    #
    # + databaseId - Id of the database
    # + requestOptions - Optional header properties
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function deleteDatabase(string databaseId, RequestOptions? requestOptions = ())
                               returns ResourceResponse|error;

    # Create a new collection.
    #
    # + databaseId - Id of the database
    # + collectionId - Id of the collection
    # + collectionCreateOptions - Optional properties
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function createCollection(string databaseId, string collectionId,
                                            CollectionCreateOptions? collectionCreateOptions = ()) returns
                                                                                                   CollectionResponse|
                                                                                                   error;
    # List collections.
    #
    # + databaseId - Id of the database
    # + requestOptions - Optional header properties
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function listCollections(string databaseId, RequestOptions? requestOptions = ()) returns
                                                                                                   DocumentCollectionsResponse
                                                                                                   |error;

    # Get a  collection.
    #
    # + databaseId - Id of the database
    # + collectionId - Id of the collection
    # + requestOptions - Optional header properties
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function getCollection(string databaseId, string collectionId, RequestOptions? requestOptions = ())
                               returns CollectionResponse|error;

    # Delete a  collection.
    #
    # + databaseId - Id of the collection
    # + collectionId - Id of the collection
    # + requestOptions - Optional header properties
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function deleteCollection(string databaseId, string collectionId, RequestOptions? requestOptions = ())
                               returns ResourceResponse|error;

    # Create a documentation.
    #
    # + databaseId - Id of the collection
    # + collectionId - Id of the collection
    # + documentId - Id of the collection
    # + documentCreateOptions - Optional header properties
    # + content - Any user-defined JSON content
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function createDocument(string databaseId, string collectionId, string documentId,
                                          DocumentCreateOptions? documentCreateOptions = (), json content) returns
                                                                                                           ResourceResponse
                                                                                                           |
                                                                                                           error;

    # List documents.
    #
    # + databaseId - Id of the database
    # + collectionId - Id of the collection
    # + documentListOptions - Optional header properties
    # + return - If success, returns DatabaseResponse, else returns `error` object
    public remote function listDocuments(string databaseId, string collectionId,
                                         DocumentListOptions? documentListOptions = ()) returns DocumentListResponse|
                                                                                                    error;

    //# Query documents.
    //#
    //# + databaseId - Id of the database
    //# + collectionId - Id of the collection
    //# + documentListOptions - Optional header properties
    //# + return - If success, returns DatabaseResponse, else returns `error` object
    //public remote function queryDocuments(string databaseId, string collectionId, @sensitive string queryString,
    //                                    Param... parameters, QueryOptions? queryOptions = ())
    //                                    returns DocumentListResponse|error;
};

remote function Client.listDatabases(RequestOptions? requestOptions = ())
                           returns DatabaseListResponse|error {
    string requestPath = SLASH + DB_PATH;
    http:Request request = new;
    var requestHeaders = costructRequestHeaders(request, "get", "dbs", EMPTY_STRING, self.masterKey, JSON_CONTENT_TYPE,
        requestOptions = requestOptions);
    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        var httpResponse = self.documentClient->get(requestPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:OK_200) {
                    ResourceResponse resourceResponse = {};
                    DatabaseListResponse databaseListResponse = {};
                    resourceResponse = extractResponseHeaders(httpResponse);
                    databaseListResponse = convertToDatabaseListResponse(jsonResponse);
                    databaseListResponse.resourceResponse = resourceResponse;
                    return databaseListResponse;
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

remote function Client.createDatabase(string databaseId, RequestOptions? requestOptions = ())
                           returns DatabaseResponse|error {
    string requestPath = SLASH + DB_PATH;
    http:Request request = new;
    json databaseJSONPayload = { "id": databaseId };
    request.setJsonPayload(databaseJSONPayload);
    var requestHeaders = costructRequestHeaders(request, "post", "dbs", EMPTY_STRING, self.masterKey, JSON_CONTENT_TYPE,
        requestOptions = requestOptions);
    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        var httpResponse = self.documentClient->post(requestPath, request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:CREATED_201) {
                    ResourceResponse resourceResponse = {};
                    DatabaseResponse databaseResponse = {};
                    resourceResponse = extractResponseHeaders(httpResponse);
                    databaseResponse = convertToDatabaseResponse(jsonResponse);
                    databaseResponse.resourceResponse = resourceResponse;
                    return databaseResponse;
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

remote function Client.getDatabase(string databaseId, RequestOptions? requestOptions = ())
                           returns DatabaseResponse|error {
    string resourceLink = DB_PATH + SLASH + databaseId;
    string requestPath = SLASH + resourceLink;
    http:Request request = new;
    var requestHeaders = costructRequestHeaders(request, "get", "dbs", resourceLink, self.masterKey, JSON_CONTENT_TYPE,
        requestOptions = requestOptions);
    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        var httpResponse = self.documentClient->get(requestPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:OK_200) {
                    ResourceResponse resourceResponse = {};
                    DatabaseResponse databaseResponse = {};
                    resourceResponse = extractResponseHeaders(httpResponse);
                    databaseResponse = convertToDatabaseResponse(jsonResponse);
                    databaseResponse.resourceResponse = resourceResponse;
                    return databaseResponse;
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

remote function Client.deleteDatabase(string databaseId, RequestOptions? requestOptions = ())
                           returns ResourceResponse|error {
    string resourceLink = DB_PATH + SLASH + databaseId;
    string requestPath = SLASH + resourceLink;
    http:Request request = new;
    var requestHeaders = costructRequestHeaders(request, "delete", "dbs", resourceLink, self.masterKey,
        JSON_CONTENT_TYPE, requestOptions = requestOptions);
    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        var httpResponse = self.documentClient->delete(requestPath, request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:NO_CONTENT_204) {
                    ResourceResponse resourceResponse = extractResponseHeaders(httpResponse);
                    return resourceResponse;
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

remote function Client.createCollection(string databaseId, string collectionId,
                                        CollectionCreateOptions? collectionCreateOptions = ()) returns
                                                                                               CollectionResponse|error
{
    string resourceLink = DB_PATH + SLASH + databaseId;
    string requestPath = SLASH + resourceLink + SLASH + COLL_PATH;
    http:Request request = new;
    json collectionJSONPayload = { "id": collectionId };
    request.setJsonPayload(collectionJSONPayload);
    var requestHeaders = costructRequestHeaders(request, "post", "colls", resourceLink, self.masterKey,
        JSON_CONTENT_TYPE, requestOptions = collectionCreateOptions.requestOptions);
    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        //Set collection specific headers.
        if (collectionCreateOptions != ()) {
            if (collectionCreateOptions.offerThroughput != ()) {
                request.setHeader("x-ms-offer-throughput", <string>collectionCreateOptions.offerThroughput);
            }
            if (collectionCreateOptions.offerType != ()) {
                request.setHeader("x-ms-offer-type", <string>collectionCreateOptions.offerType);
            }
        }
        var httpResponse = self.documentClient->post(requestPath, request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:CREATED_201) {
                    CollectionResponse collectionResponse = {};
                    ResourceResponse resourceResponse = extractResponseHeaders(httpResponse);
                    collectionResponse = convertToCollectionResponse(jsonResponse);
                    collectionResponse.resourceResponse = resourceResponse;
                    return collectionResponse;
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

remote function Client.listCollections(string databaseId, RequestOptions? requestOptions = ())
                           returns DocumentCollectionsResponse|error {
    string resourceLink = DB_PATH + SLASH + databaseId;
    string requestPath = SLASH + resourceLink + SLASH + COLL_PATH;
    http:Request request = new;
    var requestHeaders = costructRequestHeaders(request, "get", "colls", resourceLink, self.masterKey,
        JSON_CONTENT_TYPE, requestOptions = requestOptions);
    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        var httpResponse = self.documentClient->get(requestPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:OK_200) {
                    ResourceResponse resourceResponse = {};
                    DocumentCollectionsResponse documentCollectionsResponse = {};
                    resourceResponse = extractResponseHeaders(httpResponse);
                    documentCollectionsResponse = convertToDocumentCollectionsResponse(jsonResponse);
                    documentCollectionsResponse.resourceResponse = resourceResponse;
                    return documentCollectionsResponse;
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


remote function Client.getCollection(string databaseId, string collectionId, RequestOptions? requestOptions = ())
                           returns CollectionResponse|error {
    string resourceLink = DB_PATH + SLASH + databaseId + SLASH + COLL_PATH + SLASH + collectionId;
    string requestPath = SLASH + resourceLink;
    http:Request request = new;
    var requestHeaders = costructRequestHeaders(request, "get", "colls", resourceLink, self.masterKey,
        JSON_CONTENT_TYPE, requestOptions = requestOptions);
    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while encoding parameters when constructing request headers" });
        return err;
    } else {
        var httpResponse = self.documentClient->get(requestPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:OK_200) {
                    ResourceResponse resourceResponse = {};
                    CollectionResponse collectionResponse = {};
                    resourceResponse = extractResponseHeaders(httpResponse);
                    collectionResponse = convertToCollectionResponse(jsonResponse);
                    collectionResponse.resourceResponse = resourceResponse;
                    return collectionResponse;
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

remote function Client.deleteCollection(string databaseId, string collectionId, RequestOptions? requestOptions = ())
                           returns ResourceResponse|error {
    string resourceLink = DB_PATH + SLASH + databaseId + SLASH + COLL_PATH + SLASH + collectionId;
    string requestPath = SLASH + resourceLink;
    http:Request request = new;
    var requestHeaders = costructRequestHeaders(request, "delete", "colls", resourceLink, self.masterKey,
        JSON_CONTENT_TYPE, requestOptions = requestOptions);
    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while constructing request headers" });
        return err;
    } else {
        var httpResponse = self.documentClient->delete(requestPath, request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:NO_CONTENT_204) {
                    ResourceResponse resourceResponse = extractResponseHeaders(httpResponse);
                    return resourceResponse;
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

remote function Client.createDocument(string databaseId, string collectionId, string documentId,
                                      DocumentCreateOptions? documentCreateOptions = (), json content)
                           returns ResourceResponse|error {
    string resourceLink = DB_PATH + SLASH + databaseId + SLASH + COLL_PATH + SLASH + collectionId;
    string requestPath = SLASH + resourceLink + SLASH + DOC_PATH;
    http:Request request = new;
    content["id"] = documentId;
    request.setJsonPayload(content);
    var requestHeaders = costructRequestHeaders(request, "post", "docs", resourceLink, self.masterKey,
        JSON_CONTENT_TYPE, requestOptions = documentCreateOptions.requestOptions);
    if (requestHeaders is error) {
        error err = error(COSMOS_DB_ERROR_CODE,
        { message: "Error occurred while constructing request headers" });
        return err;
    } else {
        //Set collection specific headers.
        if (documentCreateOptions != ()) {
            if (documentCreateOptions.isDocumentUpsert != ()) {
                request.setHeader("x-ms-documentdb-is-upsert", <string>documentCreateOptions.isDocumentUpsert);
            }
            if (documentCreateOptions.indexingDirective != ()) {
                request.setHeader("x-ms-indexing-directive", <string>documentCreateOptions.indexingDirective);
            }
        }
        var httpResponse = self.documentClient->post(requestPath, request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:CREATED_201) {
                    ResourceResponse resourceResponse = extractResponseHeaders(httpResponse);
                    return resourceResponse;
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

remote function Client.listDocuments(string databaseId, string collectionId,
                                     DocumentListOptions? documentListOptions = ()) returns DocumentListResponse|error {
    string resourceLink = DB_PATH + SLASH + databaseId + SLASH + COLL_PATH + SLASH + collectionId;
    string requestPath = SLASH + resourceLink + SLASH + DOC_PATH;
    http:Request request = new;
    boolean continuation = true;
    string continuationToken = "";
    DocumentListResponse documentListResponse = {};
    int docCount = 0;
    while (continuation) {
        if (continuationToken != "") {
            documentListOptions.requestOptions["continuationToken"] = continuationToken;
        }
        var requestHeaders = costructRequestHeaders(request, "get", "docs", resourceLink, self.masterKey,
            JSON_CONTENT_TYPE, requestOptions = documentListOptions.requestOptions);
        if (requestHeaders is error) {
            error err = error(COSMOS_DB_ERROR_CODE,
            { message: "Error occurred while constructing request headers" });
            return err;
        } else {
            if (documentListOptions.maxItemCount != ()) {
                request.setHeader(MAX_ITEM_COUNT, <string>documentListOptions.maxItemCount);
            }
            var httpResponse = self.documentClient->get(requestPath, message = request);
            if (httpResponse is http:Response) {
                int statusCode = httpResponse.statusCode;
                var jsonResponse = httpResponse.getJsonPayload();
                if (jsonResponse is json) {
                    if (statusCode == http:OK_200) {
                        json[] jsonDocuments = <json[]>jsonResponse["Documents"];
                        foreach json jsonDocument in jsonDocuments {
                            Document document = {};
                            document = convertToDocument(jsonDocument);
                            documentListResponse.documents[docCount]= document;
                            docCount = docCount + 1;
                        }
                        if (httpResponse.hasHeader(CONTINUATION)) {
                            continuationToken = httpResponse.getHeader(CONTINUATION);
                        } else {
                            continuation = false;
                        }
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
    documentListResponse.count = docCount;
    return documentListResponse;
}


# CosmosDB Connector configurations can be setup here.
# + baseURL - The base url of the Cosmos DB account
# + masterKey - The master key of your account
# + clientConfig - Client endpoint configurations provided by the user
public type CosmosDBConfiguration record {
    string baseURL;
    string masterKey;
    http:ClientEndpointConfig clientConfig = {};
};
