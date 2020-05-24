# Streaming-Finance-Data-with-AWS-Lambda-and-Kinesis

## Data Collector with AWS Lambda
Lambda URL:
> https://mo0kje177c.execute-api.us-east-2.amazonaws.com/default/sta9760_data_collector_yin
![Alt text](https://github.com/AnnyYin/Streaming-Finance-Data-with-AWS-Lambda-and-Kinesis/blob/master/Screenshot/sta9760_data_collector_yin%20-%20Lambda%20-%20us-east-2.console.aws.amazon.com.png)

### Lambda Deployment Package
* To manage dependencies such as yfinance and boto, we can leverage a deployment package.
> lambda.zip

Upload this zip file on Lambda page, and test to ensure it works as expected.

### Lambda function for data collection

    import json
    import boto3    
    import os
    import subprocess
    import sys
    import yfinance
    def lambda_handler(event, context):
        fh = boto3.client("firehose", "us-east-2")
        stocks = ['FB', 'SHOP', 'BYND', 'NFLX', 'PINS', 'SQ', 'TTD', 'OKTA', 'SNAP', 'DDOG']
        for stock in stocks:
           stock_data = yfinance.Ticker(stock).history(start="2020-05-14", end="2020-05-15", interval="1m")
           for index, row in stock_data.iterrows():
                data = {"high":row.High, "low":row.Low, "ts":str(index), "name":stock}
                as_jsonstr = json.dumps(data)
                fh.put_record(DeliveryStreamName="sta9760_delivery_stream_yin", Record={"Data": as_jsonstr.encode('utf-8')})

## Data Tranformer
![Alt text](https://github.com/AnnyYin/Streaming-Finance-Data-with-AWS-Lambda-and-Kinesis/blob/master/Screenshot/Amazon%20Kinesis%20Firehose%20-%20us-east-2.console.aws.amazon.com.png)


## Data Analyzer with AWS Athena
