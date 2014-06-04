require 'lifx'
require 'unimidi'
require 'ruby-progressbar'

include LIFX::Colors

c = LIFX::Client.lan
c.discover!(timeout: 10)
=begin
10.times do
    pb = ProgressBar.create(:title => "Searching", :length => 100, :throttle_rate => 0.1,)
    10.times { pb.increment }
    sleep 1
end
=end

puts "I found #{c.lights.count} bulbs on the network and #{c.tags.count} Groups."

puts "Woudl you like to control a Bulb or a Group?" # Prefer this to be a selection from a list
control = gets.chomp

bulb = ["bulb", "light"]
group = ["group", "tag"]

if bulb.include?(control.downcase)
    puts "Bulbs:"
    c.lights.each_with_index do |light, index|
        puts "#{index} #{light.label}" 
    end
    puts "What Bulb would you like to control?"
    label = gets.chomp

    l = c.lights.with_label(label) # label needs to be exact or it won't work
    # I should add a way to list all bulbs and you can select from a list
   
elsif group.include?(control.downcase)
    puts "Groups"
    c.tags.each_with_index do |tag, index|
        puts "#{index} #{tag}" 
    end
    puts "What Group would you like to control?"
    tag = gets.chomp

    l = c.lights.with_tag(tag) # tag needs to be exact or it won't work
    # I should add a way to list all groups/tags and you can select from a list 
end

UniMIDI::Input.gets do |input|
$stdout.puts "Start mashing buttons"

    loop do
        m = input.gets
        chan_command, note, velocity = m.first[:data]
        $>.puts(m)
        colors = [white, red, blue, green, yellow, orange]
        color = colors[note % colors.count]
        l.set_color(color)
    end
end