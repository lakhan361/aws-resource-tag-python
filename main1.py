import boto3
import argparse
import csv



output_file="lakhan.csv"


restag = boto3.client("resourcegroupstaggingapi")
response = restag.get_resources(ResourcesPerPage=50)
tag_set=[]
for arn in response["ResourceTagMappingList"]:
    t=(arn["ResourceARN"])
#    print(arn["Tags"])


list12=(t.strip().split(':', 6))


list12=(list(set(list12)))
for i in (list12):
    if "/" in i:
        print(i.strip().split('/', 1))


"""
    for tag in arn["Tags"]:
        if tag.get('Key'):
            t=tag.get('Key')
            tag_set.append(t)
tag_set = list(set(tag_set))
print(tag_set)

with open(output_file, 'w') as csvfile:
    fieldnames = ['ResourceARN'] + tag_set
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()

    restag = boto3.client("resourcegroupstaggingapi")
    response = restag.get_resources(ResourcesPerPage=50)
    for arn in response["ResourceTagMappingList"]:
        row = {}
        for tag in arn["Tags"]:
            if tag.get('Value'):
                row[tag.get('Key')] = tag.get('Value')
        row['ResourceARN'] = arn["ResourceARN"]
        writer.writerow(row)
"""
