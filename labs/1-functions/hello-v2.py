def handler(event, context):
    print (event)

    if event['data']:
        return event['data'][::-1]
