---
layout: post
category : Tips
tagline: ""
tags : [GITHUB, GIT]
---
{% include JB/setup %}
## Cleaning your git repo files and folders (even remote ones)

To clean unused or orphan files and folders from a `github` account is really easy!
But very often, people just delete the files/folder from the project manually, using the `shift+delete` command and then follow:

```
$ git add .
$ git commit -m “whatever”
$ git push origin branch_name.
```

But this doesnt delete the files/folder from git index (or from git repo). Every time you do git status you see lots of deleted files and they are not committed in the console.



To delete files from git index(or from git repo) as well, just follow the given steps :-



### Step 1: Remove files and directories from git index
```
$ git -rm file_name
```
> This will remove files from the working tree (local) and from the index (from git repo)

***or to remove the folder***

```
$ git -rm -rf folder_name
```
> This will remove the folder from the working tree (local) and from the index (from git repo). `-r` allows recursive removal when a leading directoryname is given.


### Step 2: Commit and push the changes to github.

```
$ git add .
```
> This command updates the index using the current content found  in  the  working tree, to prepare the content staged for the next commit.

```
$ git commit -m "write your any comment here"
```
> This command stores the current contents of the index in a new commit along with a log message from the user describing the changes.
```
$ git push origin branch_name
```
> This command Updates remote refs using local refs,while ending objects necessary to complete the given refs.

_You are done and your directory is neat and clean!_