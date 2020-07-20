#!/usr/bin/env bash

for i in {1..1000}
do
	sqs_url=`aws sqs create-queue --queue-name LambdaQueue$(printf "%03d" ${i}) | jq -r '@text "\(.QueueUrl)"'`
	sqs_arn=`aws sqs get-queue-attributes --queue-url ${sqs_url} --attribute-names QueueArn | jq -r '@text "\(.Attributes.QueueArn)"'`
	aws  lambda create-event-source-mapping --event-source-arn  $sqs_arn --function-name sqsTriggerFunction
done

