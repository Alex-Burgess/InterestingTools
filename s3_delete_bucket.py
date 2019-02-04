#!/usr/bin/env python
import boto3
import sys

# Deleting buckets when versioning is enabled with the console or the cli is a real pain.'
# The boto3 api provides other options which make life easier.

def delete_bucket():
    if len(sys.argv) < 2:
        print('ERROR: Please provide the name of a bucket to be deleted. e.g. python s3_delete_bucket.py my-bucket-name')
        return False

    bucketname = sys.argv[1]

    print('Deleting all old versions in objects in bucket: ' + bucketname)
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(bucketname)
    bucket.object_versions.all().delete()

    print('Deleting bucket: ' + bucketname)
    bucket.delete()


if __name__ == '__main__':
    delete_bucket()
