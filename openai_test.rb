require "openai"
require "dotenv/load"

client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

puts "Hello! How can I help you today? (say 'bye' to exit)"
puts "-" * 50

user_input = ""

# example message list
# message_list = [
#   {
#     "role" => "system",
#     "content" => "You are a helpful assistant who talks like Shakespeare."
#   },
#   {
#     "role" => "user",
#     "content" => "Hello! What are the best spots for pizza in Chicago?"
#   }
# ]

message_list = [
  {
    "role" => "system",
    "content" => "You are a helpful assistant.",
  },
]

while user_input != "bye"
  print "Your response: "
  user_input = gets.chomp

  if user_input != "bye"
    # push the user content to the message list so it looks like the example
    message_list.push({ "role" => "user", "content" => user_input })

    # request OPENAI API
    api_response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: message_list,
      },
    )

    # get the response from the JSON
    choices = api_response.fetch("choices").at(0)
    message = choices.fetch("message")
    chat_response = message["content"]

    puts "Chat: #{chat_response}"
    puts

    # add chat response to the message list to make it a conversation
    message_list.push({ "role" => "assistant", "content" => chat_response })
  end
end

puts "Chat ended!"
