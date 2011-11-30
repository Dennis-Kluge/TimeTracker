
# TimeTracker
## About
In some companies you need to track your working time with the help of excel. For that purpose you have to create sheets and put each entry into the file by hand. TimeTracker.rb 
simplifies this workflow by adding your working time into a public iCal feed after calling timetracker a PDF for each month wil be generated. The configuration is very easy with the
help of a JSON file.

# Installation & Running
TimeTracker is tested with Ruby 1.9.2, simply install it by calling: 
	gem install timetracker.rb
	
Goto the directory where you want to create your sheets and create a config file. TimeTracker is highly configurable because of localization issues, different working times etc. 

	{
		"url" : "your url",
		
		"name" : "Your Name",
		"department" : "Your Department",
	  "year" : 2011,
		"offset" : 0,
		
		"working_time" :  {
			"january"   : 160,
			"february"  : 120,
			"march"     : 0,
			"april"     : 0,
			"may"       : 50,
			"june"      : 70,
			"july"      : 50,
			"august"    : 90,
			"september" : 160,
			"october"   : 120,
			"november"  : 100,
			"december"  : 1ß
		},
		
		"time_sheet" : {
			"title" : "Zeiterfassungsbogen",
			
			"name" : "name",
			"month" : "Monat", 
			"monthly_working_time" : "monatliche Arbeitszeit",
			"department" : "Abteilung",
			"date" : "Datum", 
			"begin" : "Begin", 
			"end" : "Ende", 
			"description" : "Beschreibung",
			"hours_without_break" : "Stunden ohne Pause",
			"break_time" : "Pausenzeit", 
			"sum" : "Summe",
			"carry" : "Übertrag",
			"correctness" : "Für die Richtigkeit der Eintragung", 
			"signature" : "Zur Kenntniss genommen",
			
			"January"   : "Januar",
			"February"  : "February",
			"March"     : "März",
			"April"     : "April",
			"May"       : "Mai",
			"June"      : "Juni",
			"July"      : "Juli",
			"August"    : "Augut",
			"September" : "September",
			"October"   : "Oktober",
			"November"  : "November",
			"December"  : "Dezember"
		}	
	}

## Contributions
Please contribute!