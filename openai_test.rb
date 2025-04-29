require "openai"
require "dotenv/load"  # Make sure .env is loaded

client = OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY"))

response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: [
      { role: "system", content: "You are a helpful assistant." },
      { role: "user", content: "Say hi!" }
    ],
    temperature: 0.7
  }
)

puts "✅ GPT replied: #{response.dig("choices", 0, "message", "content")}"
