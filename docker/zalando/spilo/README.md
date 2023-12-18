# Spilo image
This is an overriden image of [spilo](https://github.com/zalando/spilo/tree/3.0-p1) a docker image with [patroni](https://github.com/zalando/patroni) and postgresql.

## What changed from original image
The original spilo image has a set of python/bash scripts that suite different purposes. One of which is to restore a cluster from WAL-e/WAL-g backups.
Script [clone_with_wale.py](https://github.com/zalando/spilo/blob/3.0-p1/postgres-appliance/bootstrap/clone_with_wale.py) does excatl this. It tries to
1. list wal-e backups
2. takes the timestamp of the backup and compares it with the desired timestamp
3. executes command `wal-e backup-fetch` based on the results of 2

First step executes `wal-e backup-list` command and tries to parse the output to get the timestamp. The timestamp is returned in format `2021-06-23 01:00:14.498000+00:00` but only the first part of the timestamp is used so when it is being compared to the desired timestamp an error occurs
```
TypeError: can't compare offset-naive and offset-aware datetimes
```
To fix this a copy of the `clone_with_wale.py` script is used with this patch
```
diff --git a/postgres-appliance/bootstrap/clone_with_wale.py b/postgres-appliance/bootstrap/clone_with_wale.py
index e8d3196..e6c6b12 100755
--- a/postgres-appliance/bootstrap/clone_with_wale.py
+++ b/postgres-appliance/bootstrap/clone_with_wale.py
@@ -62,7 +62,7 @@ def fix_output(output):
             if started:
                 line = line.replace(' modified ', ' last_modified ')
         if started:
-            yield '\t'.join(line.split())
+            yield '\t'.join(line.split('\t'))


 def choose_backup(backup_list, recovery_target_time):
```
