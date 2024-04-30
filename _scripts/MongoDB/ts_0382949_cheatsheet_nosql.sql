/* 
** Name: Tiago Saraiva
** Assignment: Introduction to MongoDB
** Date: 2024-04-13
*/

-- -------------------------------------------------------------------
-- Unit 01: Intro to MongoDB
-- -------------------------------------------------------------------
db.hello()
db.help() -- command must start with db.<command>

-- -------------------------------------------------------------------
-- Unit 02: Get Started with MongoDB Atlas, Developer Data Platform
-- -------------------------------------------------------------------
-- Atlas - developer data platform
-- creating and deploying in Atlas cluster
-- Serverless instances - simple applications
-- Clusters - shared (personal projects) and dedicated (productions)

/*
Set up database user
Log into MOngoDB pannel
Create new Database
Create new USER
Add IP address
Load sample Data
Go to brwose collections and then sample analytics
Apply a filter in accounts -> { account_id: 794875 }
*/

-- Using CLI to configure your Atlas cluster:
atlas setup --clusterName myAtlasClusterEDU --provider AWS 
            --currentIp --skipSampleData --username myAtlasDBUser 
			--password myatlas-001 | tee atlas_cluster_details.txt

/*
Organization name: "MY_MDB_ORG"
Project name: "MDB_EDU"
Cluster name: "myAtlasClusterEDU"
Database user: "myAtlasDBUser"
Password: "myatlas-001"
Permissions: "readWriteAnyDatabase"
*/

-- -------------------------------------------------------------------
-- Unit 03: Overview of MongoDB and the Document Model
-- -------------------------------------------------------------------
-- https://www.mongodb.com/docs/manual/core/databases-and-collections/


-- Load sample data in the cluster
-- atlas clusters sampleData load myAtlasClusterEDU

-- General purpose database
-- Store documents in a similar structure to JSON files

-- The document:
-- basci unit of data

-- The collection:
-- a grouping of documents

-- Database:
-- container for collections

-- Example of document

/*
{
  "_id": 1,
  "name": "AC3 Phone",
  "colors": ["black", "silver"],
  "price": 200,
  "available": true
}
*/

-- Displayed in JON, stored in BSON
-- Stored in all JSON and more types

-- Every document requires an _id field, if not informed, it will be
-- automatically generated

-- Flexible schema
-- Simple update classes to insert new fields
-- Optional validation schemas to add CONSTRAINTS
-- Polymorphic documents

-- Syntax
{
"key": value,
"key": value,
"key": value
}

-- -------------------------------------------------------------------
-- Unit 04: Connecting to a MongoDB Database
-- -------------------------------------------------------------------
-- https://www.mongodb.com/docs/manual/reference/connection-string/
-- Connection string
-- Deployment flexibility
-- Change servers without reconfiguring clients
-- Standard format - DNS seed LIST

-- Connect driver
mongodb+srv://myAtlasDBUser:<password>
@myatlasclusteredu.t56ocro.mongodb.net
/?retryWrites=true&w=majority&appName=myAtlasClusterEDU

-- Connect shell
mongosh "mongodb+srv://myatlasclusteredu.t56ocro.mongodb.net/" 
--apiVersion 1 --username myAtlasDBUser

-- Can create JavaScript expressions in the shell

-- Create a connection to MongoDB deployment

-- -------------------------------------------------------------------
-- Unit 05: MongoDB CRUD Operations: Insert and Find Documents
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
-- https://www.mongodb.com/docs/manual/reference/method/db.collection.insertOne/
-- insertOne() method synthax
db.<collection>.insertOne()
-- db.grades.insertOne() -- always insert, if does not exist, create

db.grades.insertOne({
  student_id: 654321,
  products: [
    {
      type: "exam",
      score: 90,
    },
    {
      type: "homework",
      score: 59,
    },
    {
      type: "quiz",
      score: 75,
    },
    {
      type: "homework",
      score: 88,
    },
  ],
  class_id: 550,
})

-- acknowledge: true
-- _id: unique

-- https://www.mongodb.com/docs/manual/reference/method/db.collection.insertOne/
-- insertMany() method synthax
-- db.<collection>.insertMany([
-- 		<document1>,
-- 		<document2>,
-- 		<document3>
-- ])

db.grades.insertMany([
  {
    student_id: 546789,
    products: [
      {
        type: "quiz",
        score: 50,
      },
      {
        type: "homework",
        score: 70,
      },
      {
        type: "quiz",
        score: 66,
      },
      {
        type: "exam",
        score: 70,
      },
    ],
    class_id: 551,
  },
  {
    student_id: 777777,
    products: [
      {
        type: "exam",
        score: 83,
      },
      {
        type: "quiz",
        score: 59,
      },
      {
        type: "quiz",
        score: 72,
      },
      {
        type: "quiz",
        score: 67,
      },
    ],
    class_id: 550,
  },
  {
    student_id: 223344,
    products: [
      {
        type: "exam",
        score: 45,
      },
      {
        type: "homework",
        score: 39,
      },
      {
        type: "quiz",
        score: 40,
      },
      {
        type: "homework",
        score: 88,
      },
    ],
    class_id: 551,
  },
])

-- acknowledge: true
-- _id: unique
-- _id: unique
-- _id: unique

-- -------------------------------------------------------------------
-- https://www.mongodb.com/docs/drivers/node/current/usage-examples/findOne/
-- find() method synthax
-- return collection
-- db.<collection>.find()

-- find specific value
-- { field: { $eq: <value> } }
-- { field: <value> }

db.zips.find({ _id: ObjectId("5c8eccc1caa187d17ca6ed16") })

-- $in method synthax
-- select documents within specified value
-- db.<collection>.find({
--     <field>: { $in:
--       [<value>, <value>, ...]
--     }	  
--})

db.zips.find({ city: { $in: ["PHOENIX", "CHICAGO"] } })

-- -------------------------------------------------------------------
-- https://www.mongodb.com/docs/manual/reference/operator/query-comparison/
-- comparision operators
-- <field>: { <operator> : <value> }

-- $gt (greater than)
-- db.<collection>.find({ "<value>.<value>": { $gt: value } })

db.sales.find({ "items.price": { $gt: 50}})

-- $lt (less than)
-- db.<collection>.find({ "<value>.<value>": { $lt: value } })

db.sales.find({ "items.price": { $lt: 50}})

-- $lte (less than or equal to)
-- db.<collection>.find({ "<value>.<value>": { $lte: value } })

db.sales.find({ "customer.age": { $lte: 65}})

-- $gte (greater than or equal to)
-- db.<collection>.find({ "<value>.<value>": { $gte: value } })

db.sales.find({ "customer.age": { $gte: 65}})

-- -------------------------------------------------------------------
-- https://www.mongodb.com/docs/manual/tutorial/query-documents/
-- query arrays and Documents

db.accounts.find({ products: "InvestmentFund"})

-- $elemMatch
-- db.<collection>.find({ 
--     <value>: {
-- $elemMatch: { $eq: "<value>" })

db.sales.find({
  items: {
    $elemMatch: { name: "laptop", price: { $gt: 800 }, quantity: { $gte: 1 } },
  },
})

-- -------------------------------------------------------------------
-- https://www.mongodb.com/docs/manual/reference/operator/query-logical/
-- logical query operators

-- $and operator
-- db.<collection>.find({
--    $and: [
--      {<expression>},
--      {<expression>},
-- 		...
--    ]
-- })	  
-- also can be only a comma
-- db.<collection>.find( { <expression>, <expression> } )

-- also can be only a comma (implicit $and)
-- db.<collection>.find( { <expression>, <expression> } )

db.routes.find({ "airline.name": "Southwest Airlines", stops: { $gte: 1 } })

-- $or
-- db.<collection>.find({
--    $or: [
--      {<expression>},
--      {<expression>},
-- 		...
--    ]
-- })

db.routes.find({
  $or: [{ dst_airport: "SEA" }, { src_airport: "SEA" }],
})

-- combine $and and $or
-- db.<collection>.find({
--    $and: [
--      { $or: [
--         {<expression>},
--         {<expression>},
-- 		]},
--      { $or: [
--         {<expression>},
--         {<expression>},
-- 		]},
--    ]
--})

db.routes.find({
  $and: [
    { $or: [{ dst_airport: "SEA" }, { src_airport: "SEA" }] },
    { $or: [{ "airline.name": "American Airlines" }, { airplane: 320 }] },
  ]
})

-- when including the same operator more than once in your query,
-- you need to use the explicit $and operator.

-- -------------------------------------------------------------------
-- Unit 06: MongoDB CRUD: Replace and Delete
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
https://www.mongodb.com/docs/drivers/node/current/usage-examples/replaceOne/
-- Replacing a Document
-- replaceOne() method Syntax
-- db.<collection>.replaceOne(filter,replacement,options)
-- filter and replacement are mandatory

-- synthax Example
-- db.books.replaceOne(
--   { _id: ObjectId("62c5e671541e2c6bcb528308")}, 
--	{
--	    title: "Deep Dive into React Hooks",
--		ISBN: "0-3182-1299-4",
--		thumbnailUrl: "http://via.placeholder.com/640x360",
--		publicationDate: ISODate("2022-07-28T02:20:21.000Z"),
--		authors: ["Ada Lovelace"],
--	}
-- )

-- after run the command
-- {
--    acknowledged: true,
--    insertedId: null,
--    matchedCount: 1,
--    modifiedCount: 1,
--    upsertedCount: 0
-- }

db.books.replaceOne(
  {
    _id: ObjectId("6282afeb441a74a98dbbec4e"),
  },
  {
    title: "Data Science Fundamentals for Python and MongoDB",
    isbn: "1484235967",
    publishedDate: new Date("2018-5-10"),
    thumbnailUrl:
      "https://m.media-amazon.com/images/I/71opmUBc2wL._AC_UY218_.jpg",
    authors: ["David Paper"],
    categories: ["Data Science"],
  }
)

-- -------------------------------------------------------------------
https://www.mongodb.com/docs/drivers/node/current/usage-examples/updateOne/
-- updating a document
-- updateOne() method synthax
-- db.<collection>.updateOne(
--   <filter>,
--   <update>,
--   {options}
-- )

-- $set operator
-- adds new fields and values to a Document
-- { $set: { field: value } }

db.podcasts.updateOne(
  {
    _id: ObjectId("5e8f8f8f8f8f8f8f8f8f8f8"),
  },

  {
    $set: {
      subscribers: 98562,
    },
  }
)

-- $push operator
-- adds a value to an array
-- if field absent, adds array field with the value as its element
-- { $push: { field: "value" } }

db.podcasts.updateOne(
  { _id: ObjectId("5e8f8f8f8f8f8f8f8f8f8f8") },
  { $push: { hosts: "Nic Raboy" } }
)

-- upsert
-- insert and update a document at same time
-- synthax
-- { upsert: true }

db.podcasts.updateOne(
  { title: "The Developer Hub" },
  { $set: { topics: ["databases", "MongoDB"] } },
  { upsert: true }
)

-- -------------------------------------------------------------------
https://www.mongodb.com/docs/manual/reference/method/db.collection.findAndModify/
-- returns the document that has just been updated
-- findAndModify() method synthax
-- db.<collection>.findAndModify({
--   query: { _id: ObjectId("f8f8f8f8f8f8f8f8") },
--	 update: { $inc: { field: "value" } },
--   new: true
-- })

db.podcasts.findAndModify({
  query: { _id: ObjectId("6261a92dfee1ff300dc80bf1") },
  update: { $inc: { subscribers: 1 } },
  new: true,
})

-- -------------------------------------------------------------------
https://www.mongodb.com/docs/manual/reference/method/db.collection.updateMany/
-- filter document and update document
-- updateMany() method synthax
-- db.collection.updateMany(filter, update, options)

db.books.updateMany(
  { publishedDate: { $lt: new Date("2019-01-01") } },
  { $set: { status: "LEGACY" } }
)

-- -------------------------------------------------------------------
https://www.mongodb.com/docs/manual/reference/method/db.collection.deleteMany/
-- deleteOne() method synthax
-- db.collection.deleteOne()
-- acknowledge: true

db.podcasts.deleteOne({ _id: Objectid("6282c9862acb966e76bbf20a") })

-- deleteMany() method synthax
-- db.collection.deleteMany()

db.podcasts.deleteMany({category: “crime”})

-- -------------------------------------------------------------------
-- Unit 07: MongoDB CRUD Operations: Modifying Query Results
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
https://www.mongodb.com/docs/manual/reference/method/cursor.sort/
-- cursor.sort() method synthax
-- db.collection.find({ field: value }).sort({ <sort> })

db.companies.find({ category_code: "music" }).sort({ name: 1, _id: 1 });

-- cursor.limit() method synthax
-- db.collection.find({ field: value }).limit(<number>)

db.companies
  .find({ category_code: "music" })
  .sort({ number_of_employees: -1, _id: 1 })
  .limit(3);

-- -------------------------------------------------------------------
-- returning specific data from a query
-- db.collection.find(<query>,<projection>)

-- Return all restaurant inspections 
-- business name, result, and _id fields only
db.inspections.find(
  { sector: "Restaurant - 818" },
  { business_name: 1, result: 1 }
)

-- Return all inspections with result of "Pass" or "Warning" 
-- exclude date and zip code
db.inspections.find(
  { result: { $in: ["Pass", "Warning"] } },
  { date: 0, "address.zip": 0 }
)

-- Return all restaurant inspections 
-- business name and result fields only
db.inspections.find(
  { sector: "Restaurant - 818" },
  { business_name: 1, result: 1, _id: 0 }
)

-- -------------------------------------------------------------------
https://www.mongodb.com/docs/drivers/node/current/usage-examples/count/
-- counting documents in a collection
-- countDocuments() method synthax
-- db.collection.countDocuments(<query>,<options>)

-- Count number of docs in trip collection
db.trips.countDocuments({})

-- Count number of trips over 120 minutes by subscribers
db.trips.countDocuments({ tripduration: { $gt: 120 }, usertype: "Subscriber" })

-- -------------------------------------------------------------------
-- Unit 08: MongoDB Aggregation
-- -------------------------------------------------------------------
https://www.mongodb.com/docs/manual/aggregation/
https://www.mongodb.com/docs/manual/reference/operator/aggregation/
-- -------------------------------------------------------------------
-- build multi stage queries
-- an analysis and summary of data
-- order of stages matter

-- aggregation pipeline structure
-- db.collection.aggregate([
--    {
--        $stage1: {
--            { expression1 },
--            { expression2 }...
--        },
--        $stage2: {
--            { expression1 }...
--        }
--    }
-- ])

-- -------------------------------------------------------------------
-- $match
-- filters data that matches a criteria
-- acts like a find
-- reduce number of stages
-- db.collection.aggregate( 
--    { 
--       $match: {
--          "field_name": "value"
--       }
--    }
-- )


-- $group
-- group documents based on criteria
-- group documents by group key
-- db.collection.aggregate(
--   {
--     $group:
--      {
--         _id: <expression>, // Group key
--            <field>: { <accumulator> : <expression> }
--      }
--   }
-- )

db.zips.aggregate([
{   
   $match: { 
      state: "CA"
    }
},
{
   $group: {
      _id: "$city",
      totalZips: { $count : { } }
   }
}
])

-- -------------------------------------------------------------------
-- $sort
-- put documents in a specified order
-- 1: ascending order
-- -1: desccendig order
-- {
--     $sort: {
--         "field_name": 1
--     }
-- }

-- $limit
-- limit the number of documents at the next aggregation stage
-- {
--   $limit: 5
-- }

db.zips.aggregate([
{
  $sort: {
    pop: -1
  }
},
{
  $limit:  5
}
])

-- -------------------------------------------------------------------
-- $project
-- determine outpu shape
-- similar to find operations
-- can be inclusion or exclusion

{
    $project: {
        state:1, 
        zip:1,
        population:"$pop",
        _id:0
    }
}

-- $count
-- count total number of documents in the pipeline

{
  $count: "total_zips"
}

-- $set
-- adds or modifies fields in the pipeline

{
    $set: {
        place: {
            $concat:["$city",",","$state"]
        },
        pop:10000
     }
  }

-- -------------------------------------------------------------------
-- $out
-- create a new collection if it does not EXISTS
-- if collection exists, it replaces with new data
-- must be the last stage
-- { $out: { db: "<output-db>", coll: "<output-collection>" } }

{ $out:
  { db: "<output-db>", coll: "<output-collection>",
    timeseries: {
      timeField: "<field-name>",
      metaField: "<field-name>",
      granularity:  "seconds" || "minutes" || "hours" ,
    }
  }
}

-- -------------------------------------------------------------------
-- Unit 09: Indexes
-- -------------------------------------------------------------------
https://www.mongodb.com/docs/drivers/kotlin/coroutine/current/fundamentals/indexes/
-- -------------------------------------------------------------------
-- indexes
-- special data structures
-- store small portion of the data
-- ordered and easy to search
-- point to the document identity
-- speed queries reduce resources

-- The IXSCAN stage indicates the query is using an index and what index is being selected.
-- The COLLSCAN stage indicates a collection scan is perform, not using any indexes.
-- The FETCH stage indicates documents are being read from the collection.
-- The SORT stage indicates documents are being sorted in memory.

-- -------------------------------------------------------------------
-- single field index
-- createIndex() method synthax
-- db.collection.creatIndex({ fieldname: 1 })

db.customers.createIndex({
  birthdate: 1
})

-- unique single field index
db.customers.createIndex({
  email: 1
},
{
  unique:true
})

-- getIndex() method

db.customers.getIndexes()

-- explain () method

db.customers.explain().find({
  birthdate: {
    $gt:ISODate("1995-08-01")
    }
})
  
db.customers.explain().find({
  birthdate: {
    $gt:ISODate("1995-08-01")
    }
  }).sort({
    email:1
})  

-- -------------------------------------------------------------------
-- multikey indexes
-- index on an array field 
-- single field or compound index 
-- both below will be multikey because one of the indexes is an array 
-- db.collection.createIndex({ array:1 })
-- db.collection.createIndex({ anyfiled:1, array:1})

db.customers.createIndex({
  accounts: 1
})

-- use getIndexes() to see all indexes created in a collection
db.customers.getIndexes()

-- -------------------------------------------------------------------
-- compound indexes 
-- index on multiple fields 
-- can be multikey index if include an array field
-- limit of one array per index 
-- the order of fields in compound index matter 
-- db.collection.createIndex({active:1, field:-1, field:1})

db.customers.createIndex({
  active:1, 
  birthdate:-1,
  name:1
})

-- order of fields: Equality, Sort, Range 
db.customers.find({
  birthdate: {
    $gte:ISODate("1977-01-01")
    },
    active:true
    }).sort({
      birthdate:-1, 
      name:1
      })

db.customers.createIndex({
  active:1, 
  birthdate:-1,
  name:1
})

-- check the index used on a query 
db.customers.explain().find({
  birthdate: {
    $gte:ISODate("1977-01-01")
    },
  active:true
  }).sort({
    birthdate:-1,
    name:1
    })
	
-- cover a query by the index 
db.customers.explain().find({
  birthdate: {
    $gte:ISODate("1977-01-01")
    },
  active:true
  },
  {name:1,
    birthdate:1, 
    _id:0
  }).sort({
    birthdate:-1,
    name:1
    })		

-- -------------------------------------------------------------------
-- deleting an index 
-- too many indexes can affect system performance 

-- hideIndex() before delete 
-- db.collection.hideIndex(<index>)

-- db.collection.dropIndex(<index>)
-- to delete more than one index 
-- db.collection.dropIndexes([<index>, <index>])

-- delete by name 
db.customers.dropIndex(
  'active_1_birthdate_-1_name_1'
)

-- delete by index 
db.customers.dropIndex({
  active:1,
  birthdate:-1, 
  name:1
})

-- to delete more indexes at same time 
db.collection.dropIndexes([
  'index1name', 'index2name', 'index3name'
  ])

-- -------------------------------------------------------------------
-- Unit 10: Atlas Search
-- -------------------------------------------------------------------
https://www.mongodb.com/docs/v5.3/core/data-modeling-introduction/
-- -------------------------------------------------------------------
-- Atlas search - Using relevance-based search and seach indexes
-- search indexes - specify how records are referenced

-- -------------------------------------------------------------------
-- create a search index
-- search index with dynamic mapping 

-- click in the search tab in the MongoDB database interface
-- click in the Create Search Index Button
-- click on visualEditor
-- select a collection
-- save changes and create search index 

-- -------------------------------------------------------------------
-- static indexing 
-- fields being queried are always the same 
-- create search index 
-- select collection 
-- refine your index
-- turn off dynamic mapping 
-- create new map and save, then create search index 

-- -------------------------------------------------------------------
-- using $search and compound operators 
-- compound: must, must not, should, filter clause 
-- click on aggregation, select search
-- include your query 

$search {
  "compound": {
    "must": [{
      "text": {
        "query": "field",
        "path": "habitat"
      }
    }],
    "should": [{
      "range": {
        "gte": 45,
        "path": "wingspan_cm",
        "score": {"constant": {"value": 5}}
      }
    }]
  }
}

-- -------------------------------------------------------------------
-- search results by using facets
-- buckets that we group search results
-- toggle off dynamic mapping 
-- then make a new mapping (number/date/string)
-- save and create the search index 

$searchMeta: {
    "facet": {
        "operator": {
            "text": {
            "query": ["Northern Cardinal"],
            "path": "common_name"
            }
        },
        "facets": {
            "sightingWeekFacet": {
                "type": "date",
                "path": "sighting",
                "boundaries": [ISODate("2022-01-01"), 
                    ISODate("2022-01-08"),
                    ISODate("2022-01-15"),
                    ISODate("2022-01-22")],
                "default" : "other"
            }
        }
    }
}

-- -------------------------------------------------------------------
-- Unit 11: Introduction to MongoDB Data Modeling
-- -------------------------------------------------------------------
https://www.mongodb.com/docs/manual/data-modeling/
-- advantages of document model 
-- proper data model - what type of data and which case of use 
-- the schema is flexible to create any document 
-- normalize the data by references 
-- the opposite as the data is modeled in a relational database 
-- MongoDB the way that data is stored depends on how it is used 

-- relantionship types
-- data accessed together should be stored together 
-- common relationships - 1:1, 1:many, many:many (easy in MongoDB)
-- one to many example nested array (one document)
-- embedding - insert related data into a document
-- referencing - refer to documents in another collection 

-- embedding data in documents (ideal 1:many or many:many) 
-- avoids application joins
-- can create larger documents 

-- referencing data in documents
-- linking documents - smaller documents
-- no duplication 

-- scaling a data model 
-- efficiency: memory, cpu, query size 

-- schema anti-patterns
-- gtuidelines to work with Atlas MongoDB
-- perfomance advisor

-- -------------------------------------------------------------------
-- Unit 12: MongoDB Transactions
-- -------------------------------------------------------------------
https://www.mongodb.com/docs/mongoid/current/reference/transactions/
-- -------------------------------------------------------------------
--  ACID transactions
-- if an operation fail in a transaction 
-- guarantee transactions to ensure 
-- atomicity, consistency, isolation, durability

-- ACID transactions in MongoDB
-- single and multi-document
-- single doc operations in MongoDB are always atomic 
-- multi-documents operations need a multi-document transaction to 
-- have ACID properties 

-- using transactions in MongoDB
-- use a multi-document transaction within the shell
-- transaction has a time constraint (60 seconds)

-- .startSession()
-- .startTransaction()
-- .commitTRansaction()
-- .abortTransaction()

-- using a transaction
const session = db.getMongo().startSession()

session.startTransaction()

const account = session.getDatabase('< add database name here>').getCollection('<add collection name here>')

//Add database operations like .updateOne() here

session.commitTransaction()

-- aborting a transaction
const session = db.getMongo().startSession()

session.startTransaction()

const account = session.getDatabase('< add database name here>').getCollection('<add collection name here>')

//Add database operations like .updateOne() here

session.abortTransaction()
-- -------------------------------------------------------------------