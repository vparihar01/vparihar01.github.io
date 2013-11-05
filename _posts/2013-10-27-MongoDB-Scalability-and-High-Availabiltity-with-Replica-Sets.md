---
layout: post
category : Talks
tagline: ""
tags : [MongoDb]
title : "MongoDb scalability and high availability with Replica-Set"
---
{% include JB/setup %}

![Smaller icon](/assets/themes/twitter/bootstrap/img/mongodb.png)
, as one of the trendy and most discussed technology, has raised huge user base recently.

Most of the audience prefer practicing it or using it as back-end for their production running applications.

First thought about *MongoDB* usually tends to be another *No-SQL* database. But a better glance pushed me to explore its functionality in-depth. Easy to use and unanimous in-built functionality made it far different than other No-SQL databases.

Although, my consent is with every aspect and versatility of *MongoDB*, yet I agree that it is not a silver bullet for all your problems. One has to be clear with the use case you want to put it in, while opting for MongoDB as a back-end.


During the *MongoDB* Meetup, I didn’t prefer discussing “*What is MongoDB*” as that is something which has been taken care of by a lot of people rather, I attempted to elaborate the “**10 reasons to love mongodb**” and how comfortably we can scale it at any given point of time.

#### The 10 reasons:

1. Relatively easy to set up
2. Quite fast
3. Easily scalable 
4. High availability
5. High performance
6. Flexible schema
7. Built-in sharding & replication
8. Courses are excellent to start working as a developer/DBA.
9. Deploy new instance on demand
10. Base rather than ACID


#### BASE rather than ACID
Usually large systems are based on CAP, rather than on *ACID*, they are a *BASE*!

##### As BASE stands for:

**B**asically **A**vailable - system seems to work all the time

**S**oft State - it doesn't have to be consistent all the time

**E**ventually Consistent - becomes consistent later

Organizations nowadays tend to build their applications on *CAP & BASE*, to name a few: *Google, Yahoo, Facebook, Amazon, eBay*.

**Amazon** popularized the concept of “*Eventual Consistency*”. 

*Their definition is:* 

> The storage system guarantees that if no new updates are made to the object, eventually all accesses will return the last updated value.

#### My personal views:

* I love Mongodb for its documents and collection concept
* Flexibility in schema design (JSON type document store)
* Scalability - Just add up nodes and it can scale horizontally quite well
* MongoDB has a niche use case regarding Big Data
* High Availability using replica-set
* As there is no concept for SQL or JOINs, hence! high performance

> What else would you want from a Database, MongoDB is able to provide all at once!!

#### MongoDb Scalability
*Scalability* is one of the complicated segments to be discussed and it's tough to make a general statement. 
MongoDb has Built in *Auto-sharding* and *Replication*.

#### Sharding:
Each shard is an independent database and collectively they form one *single database*.

One of the much awaited features in *MongoDB 1.6* is replica sets, MongoDB replication solution providing automatic failure and recovery. 

##### This covers - 
* What is Replica Set? 
* Replication Process 
* Advantaged of *Replica Set* vs *Master/Slave* 
* How to set up replica set on Production Demo 

Below is the **presentation** on **MongoDb** scalability and high availability with Replica-Set which is covered in this meetup by me, it is short and covered a lot of enlightened point which is really helpful for the people who are novice in MongoBb.
{% slideshare 27617066 %}

##### Below is the session recorded video:
{% youtube PSdru23y4hk 500 400 %}

During the session I tried to explain:”**Setting up replica set on production environment**” through a video demo. Explanation gathered 3 instances which already have Mongo installed.  

##### This tutorial consists: 
1. Setup the each instance of replica set 
2. Modify the mongodb.conf to include replica set information 
3. Configure the servers to include in replica set 
4. Cross checking, if we remove primary then secondary becomes primary or not.

##### Below is the tutorial video: 
{% youtube BFSGcBHcirU 500 400 %}


> I am sure from this port, you would've found your own reason to love **MongoDB**, 