# Streaming-Finance-Data-with-AWS-Lambda-and-Kinesis

## Data Collector with AWS Lambda
Lambda function for data collection

    def lambda_handler(event, context):
        fh = boto3.client("firehose", "us-east-2")
        stocks = ['FB', 'SHOP', 'BYND', 'NFLX', 'PINS', 'SQ', 'TTD', 'OKTA', 'SNAP', 'DDOG']
        for stock in stocks:
           stock_data = yfinance.Ticker(stock).history(start="2020-05-14", end="2020-05-15", interval="1m")
           for index, row in stock_data.iterrows():
                data = {"high":row.High, "low":row.Low, "ts":str(index), "name":stock}
                as_jsonstr = json.dumps(data)
                fh.put_record(DeliveryStreamName="sta9760_delivery_stream_yin", Record={"Data": as_jsonstr.encode('utf-8')})
Lambda URL:
> https://mo0kje177c.execute-api.us-east-2.amazonaws.com/default/sta9760_data_collector_yin


## Data Tranformer



## Data Analyzer with AWS Athena
