import boto3
import argparse
import csv

#https://cevo.com.au/post/2018-05-10-aws-resource-tagging-api/

output_file="Resource-with-tag.csv"
Tag_key="Name"
Tag_value="kslave2"
filter=[{'Key': Tag_key,'Values': [Tag_value]}]


restag = boto3.client("resourcegroupstaggingapi")
response = restag.get_resources(TagFilters=filter,ResourcesPerPage=50)
tag_set=[]
for arn in response["ResourceTagMappingList"]:


    for tag in arn["Tags"]:
        if tag.get('Key'):
            t=tag.get('Key')
            tag_set.append(t)
tag_set = list(set(tag_set))
print(tag_set)


with open(output_file, 'w') as csvfile:
    fieldnames = ['ResourceARN'] +['Resource_type']+['Resource_id']+ tag_set
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()

    restag = boto3.client("resourcegroupstaggingapi")
    response = restag.get_resources(TagFilters=filter,ResourcesPerPage=50)
    for arn in response["ResourceTagMappingList"]:
        t=(arn["ResourceARN"])
        list12=(t.strip().split(':', 6))
        list12=(list(set(list12)))
        for i in (list12):
            if "/" in i:
                type_id=(i.strip().split('/', 1))
                type=type_id[0]
                id=type_id[1]

        row = {}
        for tag in arn["Tags"]:
            if tag.get('Value'):
                row[tag.get('Key')] = tag.get('Value')
        row['ResourceARN'] = arn["ResourceARN"]
        row['Resource_type']=type
        row['Resource_id']=id

        writer.writerow(row)
