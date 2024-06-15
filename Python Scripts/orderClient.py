from azure.eventhub.aio import EventHubProducerClient
from azure.eventhub import EventData
import asyncio
import random
import os
import json
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

connection_str = os.getenv("EVENTHUBCONNECTIONSTRING")
eventhub_name = os.getenv("EVENTHUBNAME")

async def run():
    producer = EventHubProducerClient.from_connection_string(conn_str=connection_str, eventhub_name=eventhub_name)

    async with producer:
        # Create a batch.
        event_data_batch = await producer.create_batch()
        # Add events to the batch.
        for _ in range(1000):
            p = random.randint(1, 10)
            q = random.randint(1, 3)
            event_data = json.dumps({'ProductID': p, 'Quantity': q})  # Convert dictionary to JSON string
            event_data_batch.add(EventData(event_data))
        # Send the batch of events to the event hub.
        await producer.send_batch(event_data_batch)

asyncio.run(run())