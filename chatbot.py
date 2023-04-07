from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer

# Create a new chatbot
bot = ChatBot('MyBot')

# Define a list of pre-defined conversation exchanges
conversation = [
    'Hello',
    'Hi there!',
    'What is your name?',
    'My name is MyBot. How can I help you?',
    'How are you?',
    'I am doing great. How about you?',
    'Bye',
    'Goodbye!'
]

# Train the chatbot using the pre-defined conversation
trainer = ListTrainer(bot)
trainer.train(conversation)

# Define the main loop for the chatbot
while True:
    try:
        # Get user input
        user_input = input('You: ')

        # Get chatbot response
        bot_response = bot.get_response(user_input)

        # Print chatbot response
        print('Bot: ', bot_response)

    # Exit if the user types "bye"
    except KeyboardInterrupt:
        print('Goodbye!')
        break
