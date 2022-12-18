# Expense Tracker

## Remote

1. Fetching the data, in json, form school website.
2. Mapping the raw data to "raw" dart classes, such as `TransactionRaw`
   in [remote.dart](entity/remote.dart).
3. Analyzing the "raw" dart classes, and transform them into several classes and enums, such
   as `Transaction` and `TranscationType` in [local.dart](entity/local.dart).

## Local

### Adding extra data

1. Adding TypeMark, `Food`, `TopUp`, `Subsidy` and so on, which can be modified manually by users.

### Persistence
- Option A: Serializing the local classes into Hive with generated TypeAdapter.
- Option B: Serializing the local classes in json for the future needs.

## 本地缓存

### 本地缓存策略概述

requestSet = 使用请求的时间区间

cachedSet = 本地已缓存的时间区间

targetSet = requestSet - cachedSet = 新的时间区间

若targetSet为空集，则直接走缓存，否则拉取targetSet时间区间的消费情况并加入本地缓存

### 缓存层存储设计

所有交易记录的索引，记录所有的交易时间，需要保证有序
+ /expense/transactionTsList

所有交易记录
+ /expense/transactions/:id

   id为主键，不能重复，可认为交易时间不会重复，故可选用交易时间的时间戳的hex为主键

已缓存的时间区间

由于可能用户在某一段时间区间内确实未进行消费，故这里必须持久化存储已缓存的时间区间

+ /expense/cachedTsRange/start

+ /expense/cachedTsRange/end

### 代码结构设计

建立抽象的Fetch接口，Remote层实现Fetch接口来拉取数据，Cache层也需要实现Fetch接口来拉取数据。

Storage层用来封装抽象`缓存层存储设计`的接口和实现。

Cache层的类构造函数需要传入`Remote层Fetch接口实现`和`持久化存储接口实现`。

Cache层自身也作为一个Fetch接口的实现，其中的fetch方法需要基于remote层与持久化层编写缓存策略的代码逻辑，体现了一种装饰器模式的思想。

## Display
Transactions are page-splitted by month to display with an endless lazy column.

