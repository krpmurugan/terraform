# Azure Cosmos DB

Azure Cosmos DB is a Microsoft’s globally distributed, multi-model database service. It enables scaling the throughput elastically and independently. Also, it offers storage across any number of Azure regions worldwide. Cosmos DB provides comprehensive service level agreements for throughput, latency, availability, and consistency guarantees.

## CosmosDB Entities Hierarchy

There are different entities available under Cosmos DB accounts, databases, containers and items. Cosmos DB also has entities like stored procedures, user defined functions, triggers, conflicts.

### Databases

Every Cosmos DB account can have one or more databases. It is like namespaces, which is used to manage the containers. You can perform Create New, Update database, Read Database and Enumerate all databases operations on Cosmos DB account.

Cosmos DB supports five flavors of APIs for the developer’s convenience.

| Azure Cosmos DB | Database | Container  | Item         |
| --------------- | -------- | ---------- | ------------ |
| Core SQL API    | Database | Container  | Document     |
| Cassandra API   | Keyspace | Table      | Row          |
| MongoDB API     | Database | Collection | Document     |
| Gremlin API     | Database | Graph      | Node or Edge |
| Table API       | N/A      | Table      | Item         |

### Containers

Every database can have multiple containers. An Azure Cosmos DB container is unit of scalability for both provisioned throughput and storage.

A container horizontally partitioned based on partition key and then the data can be replicated across different Azure regions. A container can scale elastically based on either dedicated throughput or shared throughput settings.

One important characteristics of container is absence of schema management. In a container, you can create items of varying schema. That is because container does not enforce schema on the containers.

You can also set time to live for item or for the container to gracefully remove them. When time to live expires, then the items are automatically removed by Cosmos DB.

You can register stored procedures, triggers, user-defined functions (UDFs), and merge procedures for your Azure Cosmos container.

You can perform Create new container, Update container, Read container, Delete container and Enumerate all containers operations on the containers.

Below are the system properties of every container. First four properties are system generated, while others can be configured by users.

| Property         | Purpose                                                                            |
| ---------------- | ---------------------------------------------------------------------------------- |
| \_rid            | The unique resource identifier for container                                       |
| \_etag           | Entity tag for optimistic concurrency                                              |
| \_ts             | Last updated timestamp of container                                                |
| \_self           | Addressable URI of container                                                       |
| id               | User defined unique name for the container                                         |
| indexingPolicy   | Ability to change index path / mode / type.                                        |
| TimeToLive       | Set expiry time on container, after which container will be automatically deleted. |
| changeFeedPolicy | Used to read changes to items in container                                         |
| uniqueKeyPolicy  | Used to ensure uniqueness of one or more values in logical partition               |

### Items

You can use any of the APIs to add items to the container. Every item in container has some system generated properties or user defined properties.

User defined properties are the properties required for your application. Below are the system generated properties and their purposes.

You can represent a Cosmos item as a document in a collection, row in a table, node, or edge in a graph. The below table shows the Cosmos Item against each Cosmos Entity.

| Property | Purpose                                                                                                                                 |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| \_rid    | Unique identifier for an item                                                                                                           |
| \_etag   | Entity tag for optimistic concurrency                                                                                                   |
| \_ts     | Timestamp of last update of an item                                                                                                     |
| \_self   | Addressable URI of item                                                                                                                 |
| id       | This property can either be generated by system or user can specify them while creating container. It is to uniquely identify the item. |

### High Throughput

With single-digit millisecond reads and writes worldwide and with the capability to elastically scale from thousands to hundreds of millions of requests per second, Cosmos DB offers unparalleled throughput.

### Low Latency

Cosmos DB ensures less than ten milliseconds latency for reads and writes at the 99th percentile worldwide. This capability enables the applications to be highly responsible.

### Global Distribution

To achieve low latency and high availability, you can deploy instances of the applications in multiple data centers. Globally distributed applications require a globally distributed database. Cosmos DB seamlessly replicates the data to all the Azure regions associated with the Cosmos account while maintaining the application’s high availability.

### Multi-Consistency Model

Distributed applications make a fair trade-off between data consistency, availability, and latency. Cosmos DB’s multi-master replication model offers five consistency models: strong, bounded staleness, session, consistent prefix, and eventual for an intuitive programming model with low latency and high availability for a globally distributed application. The consistency levels are region-agnostic and are guaranteed for all operations regardless of the region.
