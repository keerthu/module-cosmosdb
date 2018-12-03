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

public type SQLType TYPE_VARCHAR|TYPE_CHAR|TYPE_LONGVARCHAR|TYPE_NCHAR|TYPE_LONGNVARCHAR|TYPE_NVARCHAR|TYPE_BIT|
TYPE_BOOLEAN|TYPE_TINYINT|TYPE_SMALLINT|TYPE_INTEGER|TYPE_BIGINT|TYPE_NUMERIC|TYPE_DECIMAL|TYPE_REAL|TYPE_FLOAT|
TYPE_DOUBLE|TYPE_BINARY|TYPE_BLOB|TYPE_LONGVARBINARY|TYPE_VARBINARY|TYPE_CLOB|TYPE_NCLOB|TYPE_DATE|TYPE_TIME|
TYPE_DATETIME|TYPE_TIMESTAMP|TYPE_ARRAY|TYPE_STRUCT|TYPE_REFCURSOR;

public const TYPE_VARCHAR = "VARCHAR";
public const TYPE_CHAR = "CHAR";
public const TYPE_LONGVARCHAR = "LONGVARCHAR";
public const TYPE_NCHAR = "NCHAR";
public const TYPE_LONGNVARCHAR = "LONGNVARCHAR";
public const TYPE_NVARCHAR = "NVARCHAR";
public const TYPE_BIT = "BIT";
public const TYPE_BOOLEAN = "BOOLEAN";
public const TYPE_TINYINT = "TINYINT";
public const TYPE_SMALLINT = "SMALLINT";
public const TYPE_INTEGER = "INTEGER";
public const TYPE_BIGINT = "BIGINT";
public const TYPE_NUMERIC = "NUMERIC";
public const TYPE_DECIMAL = "DECIMAL";
public const TYPE_REAL = "REAL";
public const TYPE_FLOAT = "FLOAT";
public const TYPE_DOUBLE = "DOUBLE";
public const TYPE_BINARY = "BINARY";
public const TYPE_BLOB = "BLOB";
public const TYPE_LONGVARBINARY = "LONGVARBINARY";
public const TYPE_VARBINARY = "VARBINARY";
public const TYPE_CLOB = "CLOB";
public const TYPE_NCLOB = "NCLOB";
public const TYPE_DATE = "DATE";
public const TYPE_TIME = "TIME";
public const TYPE_DATETIME = "DATETIME";
public const TYPE_TIMESTAMP = "TIMESTAMP";
public const TYPE_ARRAY = "ARRAY";
public const TYPE_STRUCT = "STRUCT";
public const TYPE_REFCURSOR = "REFCURSOR";

public type RequestOptions record {
    string consistencyLevel?;
    string sessionToken?;
    int partitionKeyRangeId?;
    string continuationToken?;
    int pageSize?;
};

public type ResourceResponse record {
    string etag?;
    string activityId?;
    string alternateContentPath?;
    int itemCount?;
    int maxResourceQuota?;
    int currentResourceUsage?;
    string sessionToken?;
    int requestCharge?;
};

public type DatabaseResponse record {
    ResourceResponse resourceResponse = {};
    Database database = {};
};

public type Database record {
    string id = "";
    string rid = "";
};

public type DatabaseListResponse record {
    ResourceResponse resourceResponse = {};
    Database[] databases = [];
};

public type DocumentCollectionsResponse record {
    ResourceResponse resourceResponse = {};
    Collection[] documentCollections = [];
    int count = 0;
};

public type CollectionCreateOptions record {
    RequestOptions requestOptions = {};
    int offerThroughput?;
    string offerType?;
};

public type CollectionResponse record {
    ResourceResponse resourceResponse = {};
    Collection collection = {};
};

public type DocumentQueryOptions record {
    RequestOptions requestOptions = {};
};

public type DocumentCreateOptions record {
    RequestOptions requestOptions = {};
    boolean isDocumentUpsert = false;
    string indexingDirective = "";
};

public type Collection record {
    string id = "";
    string rid = "";
};

public type Document record {
    string id?;
    string rid?;
    string etag?;
    json content?;
};

public type DocumentListResponse record {
    Document[] documents = [];
    int count?;
};

public type DocumentListOptions record {
    int maxItemCount?;
    RequestOptions requestOptions = {};
};

public type Parameter record {
    SQLType sqlType;
    any value = ();
    !...
};

# The parameter passed into the operations.
type Param string|int|boolean|float|byte[]|Parameter;