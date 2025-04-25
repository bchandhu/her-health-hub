desc "Fill the database tables with some sample data"
task sample_data: :environment do
  puts "🌱 Seeding sample data into the database..."

  # Create a demo user (only if one doesn't exist)
  user = User.find_or_create_by!(email: "demo@example.com") do |u|
    u.password = "password"
    u.name = "Demo User"
  end

  puts "👤 User: #{user.email}"

  # Create sample diagnostics
  3.times do |i|
    user.diagnostic_responses.create!(
      raw_input: "Periods irregular: Yes. Acne: No. Weight gain: Yes. Facial hair: No. Stress level: Medium. Cycle length: 35–60 days. Cramp intensity: Moderate. Family history: Yes.",
      gpt_response: "Based on your responses, there is a medium risk of PCOS. Consider visiting a healthcare professional.",
      risk_level: ["Low", "Medium", "High"].sample
    )
  end
  puts "🧠 Created 3 sample diagnostics"

  # Create sample period logs
  5.times do |i|
    user.calendar_entries.create!(
      date: Time.zone.today - i.days,
      note: "Sample log for #{(Time.zone.today - i.days).strftime('%B %d')}: mild cramps and mood swings."
    )
  end
  puts "📅 Created 5 recent period log entries"

  puts "✅ Done!"
end
