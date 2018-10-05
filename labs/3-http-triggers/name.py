def handler(event, context):
    print (event)
    print (context)

    name = 'Unknown'

    if event['data'] and 'name' in event['data']:
        name = event['data'].get('name')

    return "Hello %s" % (name)
