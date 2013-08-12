---
layout: post
category : Tips
tagline: ""
tags : [GITHUB, GIT]
---
{% include JB/setup %}
Tips to delete, remote and local branch from ***GIT*** e.g ***github***, ***bucket***

Deleting a remote as well as a local branch from git is pretty simple.
## To delete a remote branch -:

### Step 1: Just go into your project directory from console/gitbash(if you are using windows)

In console enter-:
```
$ git branch -r
```

> You see a list of the remote branches .
```
origin/HEAD -> origin/master
origin/design
origin/develop
origin/feature
origin/master
```

### Step 2: If you want to delete the branch name `develop` from `git(Github)`

Then enter in the console-:
```
$ git push origin :develop
```
(Where `origin` is your remote name and `develop` is the name of the branch)

> The above command will delete the ***develop*** branch on the origin remote



## To delete a local branch -:



### Step 1: First, make sure you are not on the same branch (eg. `develop`) which you are going to delete from the local repo also. Just move from that branch to another branch using
```
$ git checkout branch_name
```

### Step 2: Then enter in the console:
```
$ git branch -d develop
```

> This will delete the branch locally as well.

***.........Well Done.........***