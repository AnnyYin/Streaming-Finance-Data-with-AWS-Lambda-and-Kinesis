# Streaming-Finance-Data-with-AWS-Lambda-and-Kinesis

AWS provides us various services that make streaming data analysis easier. With Lambda, we are able to pull data from external source, and load it to Kinesis firehose in one step, then Kinesis, a streaming data pipeline, will deliver our data to a data store, like S3 bucket. Now it's easy to load data to analysis tools, in this case Athena, with Glue as ETL service.

In this project, we will go through the whole streaming data analysis process on finance data from yahoo!finance, and perform simple query on the data.

## Data Collector with AWS Lambda
Here we use AWS Lambda to collect stock price data from yfinance and send the data to a Kinesis Firehose, which will further load data to a S3 bucket.

Lambda URL:
> https://mo0kje177c.execute-api.us-east-2.amazonaws.com/default/sta9760_data_collector_yin
![Alt text](https://github.com/AnnyYin/Streaming-Finance-Data-with-AWS-Lambda-and-Kinesis/blob/master/Screenshot/sta9760_data_collector_yin%20-%20Lambda%20-%20us-east-2.console.aws.amazon.com.png)

### Lambda Deployment Package
* To manage dependencies such as yfinance and boto, we can leverage a deployment package.
> Guidance: https://github.com/mottaquikarim/STA9760_simple_deployment_package

With Docker, we can create dependecy package, rather than install via subprocess(which doesn't work on my Lambda function). Then we can simply import packages we need in the code as below.

### Lambda function for data collection
We pick stock name, 'high'/'low' stock price and the datetime data for further analysis. Data is formatted in this Lambda function.

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
                
        return {'statusCode': 200,
            'body': json.dumps(f'Done! Recorded: {as_jsonstr}')}

## Data Tranformer
Since I have set a data transformer(a Lambda function) when I created the Kinesis Firehose, data sent to this Firehose will be tranformed automatically, and then be sent to prescribed S3 bucket.

![Alt text](https://github.com/AnnyYin/Streaming-Finance-Data-with-AWS-Lambda-and-Kinesis/blob/master/Screenshot/Amazon%20Kinesis%20Firehose%20-%20us-east-2.console.aws.amazon.com.png)


## Data Analyzer with AWS Athena
Now we can use AWS Athena to query data stored in S3 bucket. In Athena, you can simply query the data with SQL.
Before that, Glue, an ETL service is used to extract data from S3 and load data to Athena. 

See SQL query in:
> query.sql
    
See querying results in:
> results.csv
