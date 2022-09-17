require "date"
require "colorize"
# Data
date = Date.today
id = 0
@colores_calendar = { "web-dev" => :light_red, "english" => :light_magenta, "soft-skills" => :green }
events = [
  { id: (id = id.next),
    start_date: "2022-08-15T00:00:00-05:00",
    title: "Ruby Basics 1",
    end_date: "",
    notes: "Ruby Basics 1 notes",
    guests: %w[Teddy Codeka],
    calendar: "web-dev" },
  { id: (id = id.next),
    start_date: "2022-08-15T12:00:00-05:00",
    title: "English Course",
    end_date: "2022-08-15T13:30:00-05:00",
    notes: "English notes",
    guests: ["Stephanie"],
    calendar: "english" },
  { id: (id = id.next),
    start_date: "2022-08-16T00:00:00-05:00",
    title: "Ruby Basics 2",
    end_date: "",
    notes: "Ruby Basics 2 notes",
    guests: %w[Andre Codeka],
    calendar: "web-dev" },
  { id: (id = id.next),
    start_date: "2022-08-16T12:45:00-05:00",
    title: "Soft Skills - Mindsets",
    end_date: "2022-08-15T13:30:00-05:00",
    notes: "Some extra notes",
    guests: ["Diego"],
    calendar: "soft-skills" },
  { id: (id = id.next),
    start_date: "2022-08-17T00:00:00-05:00",
    title: "Ruby Methods",
    end_date: "",
    notes: "Ruby Methods notes",
    guests: %w[Diego Andre Teddy Codeka],
    calendar: "web-dev" },
  { id: (id = id.next),
    start_date: "2022-08-17T12:00:00-05:00",
    title: "English Course",
    end_date: "2022-08-15T13:30:00-05:00",
    notes: "English notes",
    guests: ["Stephanie"],
    calendar: "english" },
  { id: (id = id.next),
    start_date: "2022-08-18T09:00:00-05:00",
    title: "Extended Project",
    end_date: "",
    notes: "",
    guests: [],
    calendar: "web-dev" },
  { id: (id = id.next),
    start_date: "2022-08-18T09:00:00-05:00",
    title: "Summary Workshop",
    end_date: "2022-08-19T13:30:00-05:00",
    notes: "A lot of notes",
    guests: %w[Diego Teddy Andre Codeka],
    calendar: "web-dev" },
  { id: (id = id.next),
    start_date: "2022-08-19T09:00:00-05:00",
    title: "Extended Project",
    end_date: "",
    notes: "",
    guests: [],
    calendar: "web-dev" },
  { id: (id = id.next),
    start_date: "2022-08-19T12:00:00-05:00",
    title: "English for Engineers",
    end_date: "2022-08-19T13:30:00-05:00",
    notes: "English notes",
    guests: ["Stephanie"],
    calendar: "english" },
  { id: (id = id.next),
    start_date: "2022-08-20T10:00:00-05:00",
    title: "Breakfast with my family",
    end_date: "2022-08-20T11:00:00-05:00",
    notes: "",
    guests: [],
    calendar: "default" },
  { id: (id = id.next),
    start_date: "2022-08-20T15:00:00-05:00",
    title: "Study",
    end_date: "2022-08-20T20:00:00-05:00",
    notes: "",
    guests: [],
    calendar: "default" },
  { id: (id = id.next),
    start_date: "2022-08-25T09:00:00-05:00",
    title: "Extended Project",
    end_date: "",
    notes: "",
    guests: [],
    calendar: "web-dev" },
  { id: id.next,
    start_date: "2022-08-26T09:00:00-05:00",
    title: "Extended Project",
    end_date: "",
    notes: "",
    guests: [],
    calendar: "web-dev" }
]
# Methods

# Parameters: date: Date, events: Array
# Submethods: print_events, get_week_init_date, get_week_end_date
# Description: Prints the events of the current week
def list_events(date, events)
  puts "#{'-' * 29}Welcome to CalenCLI#{'-' * 29}\n\n"
  monday = get_week_init_date(date)
  sunday = get_week_end_date(date)

  day = monday
  while day <= sunday
    filtered_events = events.filter { |e| Date.parse(e[:start_date]) == day }
    if filtered_events.empty?
      puts "#{day.strftime('%a %b %d')}#{' ' * 16}No events\n\n"
    else
      print_events(day, filtered_events)
    end
    day += 1
  end
end

# Parameters: events: Array
# Submethods: prompt_event
# Description: Prompts the user to create an event and store it in the array
def create_event(events)
  event = prompt_event

  events.push({ id: events.last[:id].next,
                start_date: event[:start_date],
                title: event[:title],
                end_date: event[:end_date],
                notes: event[:notes],
                guests: event[:guests],
                calendar: event[:calendar] })
end

# Parameters: id: Integer, events: Array
# Submethods: print_event
# Description: Prints the event corresponding to the ID
def show_event(id, events)
  event = events.find { |e| e[:id] == id }
  if event.nil?
    puts "Event ID #{id} does not exist"
  else
    print_event(event)
  end
end

# Parameters: id: Integer, events: Array
# Submethods: prompt_event
# Description: Updates the event corresponding to the ID
def update_event(id, events)
  event = events.find { |e| e[:id] == id }
  if event.nil?
    puts "Event ID #{id} does not exist"
  else
    prompt_event(event)
  end
end

# Parameters: id: Integer, events: Array
# Submethods: prompt_event
# Description: Deletes the event corresponding to the ID
def delete_event(id, events)
  events.delete_if { |e| e[:id] == id }
end

# Description: Prints option menu in the terminal
def show_menu
  puts "-" * 78
  puts "list | create | show | update | delete | next | prev | exit\n\n"
end

# Parameters: message : String
# Description: Shows the message and gets the user input
def grab_input(message:)
  print message
  gets.chomp
end

# Parameters: message : String, error_message: String
# Description: Shows the message and validates the date format of the input
def grab_date(message:, error_message:)
  loop do
    date = grab_input(message: message)
    return date if date.match(/\d{4}-\d{2}-\d{2}/)

    puts error_message
  end
end

# Parameters: message : String, error_message: String
# Description: Shows the message and validates the title is not empty
def grab_title(message:, error_message:)
  loop do
    title = grab_input(message: message)
    return title unless title.empty?

    puts error_message
  end
end

# Parameters: date: Date, message : String
# Description: Shows the message and validates the time
def grab_start_end(date, message:)
  date_format = "%Y-%m-%dT%H:%M:%S-05:00"
  loop do
    start_end = grab_input(message: message)
    return { start_date: date, end_date: "" } if start_end.empty?

    if start_end.match(/\d{2}:\d{2} \d{2}:\d{2}/)
      date_start = get_date_start(Date.parse(date), start_end.split[0])
      date_end = get_date_start(Date.parse(date), start_end.split[1])

      if date_start <= date_end
        return { start_date: date_start.strftime(date_format), end_date: date_end.strftime(date_format) }
      end

      puts "Cannot end before start"
    else
      puts "Format: HH:MM HH:MM or leave it empty\n"
    end
  end
end

# Parameters: day: Date, events: Array
# Submethods: ordered_events print_lines_events
# Description: prints the events of the week stored in the array formatted to the clients specifications
def print_events(day, events)
  ordered_events = order_events(events)
  print day.strftime("%a %b %d").to_s
  ordered_events.each do |event|
    s_hour = event[:start_date][11, 5]
    e_hour = event[:end_date][11, 5]
    title = event[:title].colorize(@colores_calendar[event[:calendar]])
    print_lines_events(ordered_events, event, s_hour, e_hour, title)
  end
  puts "\n"
end

# Parameters: events: Array
# Description: orders events, daily events always on top
def order_events(events)
  ordered_events = events.filter { |e| e[:end_date].empty? }
  events.each do |e|
    ordered_events.push(e) unless e[:end_date].empty?
  end
  ordered_events
end

# Parameters: events: Array, event: Hash, s_hour: String, e_hour: String, title: String
# Description: prints individual lines
def print_lines_events(events, event, s_hour, e_hour, title)
  if events.index(event).zero? && event[:end_date] == ""
    print "#{' ' * 16}#{title} (#{event[:id]})\n".colorize(@colores_calendar[event[:calendar]])
  elsif events.index(event).zero? && event[:end_date] != ""
    print "#{' ' * 2}#{s_hour} - #{e_hour} #{title} (#{event[:id]})\n"
  elsif events.index(event) != 0 && event[:end_date] == ""
    print "#{' ' * 26}#{title} (#{event[:id]})\n"
  else
    print "#{' ' * 12}#{s_hour} - #{e_hour} #{title} (#{event[:id]})\n"
  end
end

# Parameters: day: Date, hour_minute: Array
# Description: Joins the date , hour and miture to create a new DateTime value
def get_date_start(date, hour_minute)
  h = hour_minute.split(":")[0].to_i
  mm = hour_minute.split(":")[1].to_i
  y = date.year
  m = date.month
  d = date.day
  DateTime.new(y, m, d, h, mm, 0, "-05:00")
end

# Parameters: event: Hash
# Description: prints the details of the event
def print_event(event)
  puts "date: #{event[:start_date]}"
  puts "title: #{event[:title]}"
  puts "calendar: #{event[:calendar].to_s.colorize(@colores_calendar[event[:calendar]])}"
  puts "start_end: #{event[:end_date][11, 5]} #{event[:end_date][11, 5]}"
  puts "notes: #{event[:notes]}"
  print "guests: #{event[:guests].join(', ')}\n"
end

# Parameters: event: Hash
# Description: Promts the user to enter event details
def prompt_event(event = {})
  start_date = grab_date(message: "date: ", error_message: "Type a valid date: YYYY-MM-DD\n")

  event[:title] = grab_title(message: "title: ", error_message: "Title cannot be blank: \n")
  event[:calendar] = grab_input(message: "calendar: ")

  start_end = grab_start_end(start_date, message: "start_end: ")
  event[:start_date] = start_end[:start_date]
  event[:end_date] = start_end[:end_date]

  event[:notes] = grab_input(message: "notes: ")
  event[:guests] = grab_input(message: "guests: ").split(",")
  event
end

# Parameters: date: Date
# Description: Outputs the neares Monday of the current week
def get_week_init_date(date)
  date -= 1 until date.monday?
  date
end

# Parameters: date: Date
# Description: Outputs the neares Sunday of the current week
def get_week_end_date(date)
  date += 1 until date.sunday?
  date
end

# Main Program
action = ""
list_events(date, events)

until action == "exit"
  show_menu
  action = grab_input(message: "action: ")

  case action
  when "list"
    list_events(date, events)
  when "create"
    create_event(events)
  when "show"
    requested_id = grab_input(message: "Event ID: ").to_i
    show_event(requested_id, events)
  when "update"
    requested_id = grab_input(message: "Event ID: ").to_i
    update_event(requested_id, events)
  when "delete"
    requested_id = grab_input(message: "Event ID: ").to_i
    delete_event(requested_id, events)
  when "next"
    date += 7
    list_events(date, events)
  when "prev"
    date -= 7
    list_events(date, events)
  when "exit"
    puts "Thanks for using calenCLI"
  end
end
