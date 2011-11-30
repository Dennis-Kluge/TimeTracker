require "time_tracker/version"
	
	
require 'iCalendar'
require 'date'
require 'prawn'
require 'json'
require 'httpclient'
	
module TimeTracker
	
	
	class TimeTracker::Month
	  
	  attr_reader :monthly_working_time, :entries
	  # offset means +/- hours within this month
	  # global_offset within the whole year as a sum
	  attr_accessor :offset, :global_offset, :fixed_monthly_working_time      
	  
	  def initialize
	    @entries = Array.new
	    #@fixed_monthly_working_time      
	  end
	  
	  def add_event event
	    @entries.push(Entry.new(event))
	  end
	  
	  def sort_entries!
	    @entries.sort! { |a,b| a.start_time <=> b.start_time }
	  end
	  
	  def calulate_working_time 
	    @monthly_working_time = 0
	    @entries.each do |entry|
	     @monthly_working_time += entry.duration	     
	    end    	    
	    @offset = @monthly_working_time - @fixed_monthly_working_time      
	    @global_offset += @offset
	  end
	  
	  def to_s
	    entries = "Entries: \n"
	    @entries.each do |entry|
	      entries += "#{entry} \n"
	    end
	    entries
	  end
	  
	  private   
	  def add_entry entry
	    @entries.push entry
	  end
	  
	end
	
	class TimeTracker::Entry
	  attr_accessor :start_time, :end_time, :summary, :duration
	  attr_reader :break_time
	  
	  def initialize event
	    @start_time = event.dtstart
	    @end_time = event.dtend
	    @summary = event.summary
	    @duration = calculate_duration 
	  end
	    
	  private 
	  def calculate_duration 
	    # duration in hours
	    duration = (@end_time.hour - @start_time.hour).to_f 
	      
	    # break_one	   
	    if duration >= 6 then
	      duration -= 0.5
	      @break_time = 0.5
	    # break_two
	    elsif duration >= 9 then
	      duration -= 0.75
	      @break_time = 0.75
	    else 
	      @break_time = 0
	    end      
	      duration
	  end  
	  
	  
	  # just for debugging
	  def to_s
	    "start: #{@start_time}, end: #{@end_time}, summary: #{@summary}"
	  end
	   
	end
	
	class TimeTracker::TimeSheet
	  def initialize month, config
	    @month = month
	    @config = config
	  end
	  
	  def print
	    # you worked this month
	    if @month.entries.length > 0 then	
				# get localized month name
				config = @config
				temp_name = @month.entries[0].start_time.strftime("%B")				
	      month_name = config["time_sheet"][temp_name]
	      # why namespace clashing here? 
	      entries = @month.entries
	      month = @month	      
	      Prawn::Document.generate("#{month_name}.pdf") do
	        #heading        
	        font_size 16
	        text "#{config["time_sheet"]["title"]}", :style => :bold, :align => :center
	        font_size 12
	        move_down 5
	        text "#{config["time_sheet"]["name"]}: #{config["name"]}"
	        text "#{config["time_sheet"]["month"]}: #{month_name}"
	        text "#{config["time_sheet"]["monthly_working_time"]}: #{month.fixed_monthly_working_time}"
	        text "#{config["time_sheet"]["department"]}: #{config["department"]}"
	        table_data = Array.new
	        # fill table header
	        table_data.push [#{config["time_sheet"]["date"]}, 
	        								 #{config["time_sheet"]["begin"]}, 
	        								 #{config["time_sheet"]["end"]},
	        								 #{config["time_sheet"]["description"]}, 
	        								 #{config["time_sheet"]["hours_without_break"]},
	        								 #{config["time_sheet"]["break_time"]}
	        								 ]
	        								 
	        entries.each do |entry|
	          row_data = Array.new
	          row_data.push "#{entry.start_time.strftime("%d")}."
	          row_data.push "#{entry.start_time.strftime("%H")}:#{entry.start_time.strftime("%M")}"
	          row_data.push "#{entry.end_time.strftime("%H")}:#{entry.end_time.strftime("%M")}"
	          row_data.push entry.summary
	          row_data.push entry.duration
	          row_data.push entry.break_time          
	          table_data.push row_data
	        end            
	        move_down 5
	        table table_data  
	        move_down 5
	        text "#{config["time_sheet"]["sum"]}: #{month.monthly_working_time}"
	        move_down 5    
	        text "#{config["time_sheet"]["carry"]}: #{month.global_offset}"
	        move_down 50
	        text "__________________________"
	        text "#{config["time_sheet"]["correctness"]}"
	        move_down 50
	        text "__________________________"
	        text "#{config["time_sheet"]["signature"]}"
	      end
	    end        
	  end  
	  
	end
	
	class TimeTracker::Creator
		
		def initialize 

			# configuration stuff
			begin
				config_file = File.read "config.json"
			rescue
				puts "Can't read configuration file"
			end
			@config = JSON.parse config_file
			
			# Open a file or pass a string to the parser
			client = HTTPClient.new
			cal_file = client.get_content @config["url"]			
			
			# Parser returns an array of calendars because a single file
			# can have multiple calendars.
			cals = Icalendar.parse cal_file
			cal = cals.first
			
			# initialize months, yep 1 to 13 cause we can use month 1..12
			# a little bit unclean but the use is more intuitive
			@months = Array.new
			13.times do 
			  @months.push Month.new
			end
			
			
			# sort each event into the right month
			cal.events.each do |event|  
			  if event.start.year == @config["year"] then
			    @months[event.start.month].add_event event
			  end
			end
		end
	
		def index_to_month i
		  result = ""
		  case i 
		  when 1
		    result = "january"
		  when 2
		    result = "february"
		  when 3
		    result = "march"
		  when 4
		    result = "april"
		  when 5
		    result = "may"
		  when 6
		    result = "june"
		  when 7
		    result = "july"
		  when 8
		    result = "august"
		  when 9
		    result = "september"
		  when 10
		    result = "october"
		  when 11
		    result = "november"
		  when 12
		    result = "december"
		  else 
		    result = "error"
		  end
		  result
		end
	
		def start_tracking
			# sort events within the month and calculate +/- hours
			temp_offset = @config["offset"];
			config = @config
			@months.each_with_index do |month, i|
			  if i > 0 then
			    month.sort_entries!
			    month.global_offset = temp_offset
			    # reading monthly working time with some dirty conversion for a more beautiful configuration file
			    month.fixed_monthly_working_time = @config["working_time"][(index_to_month i)]
			    month.calulate_working_time   # monthly_working_time
			    temp_offset = month.global_offset
			    sheet = TimeSheet.new month, config
			    sheet.print
			  end
			end
		end
	end
end
