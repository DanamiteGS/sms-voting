# README

The purpose of the app is to track votes for each candidate that is part of a campaign. Users should be to explore the list of campaigns, view associated candidates, and access the relevant voting details.

![model-relations](https://github.com/DanamiteGS/sms-voting/assets/91506697/3937d2ef-5898-426c-891d-b752674083ab)

Here we can see a clear relationship between campaigns, their participating candidates, and their votes. In order to easily query and display a list of campaigns and candidates, I extracted these fields from the log data into their own respective models.  Votes can then be accessed within the context of a candidate (or campaign) through a `has_many` association.

## Class Overview:
### Campaign:
The Campaign model uniquely identified by its `name` and allows us to easily obtain a list of campaigns that have votes.

### Candidate:
The Candidate model represents the candidates that people have voted for in each campaign. Each candidate is uniquely identified by an id and their association to the campaign they belong to. This ensures that candidates are correctly identified even if they share the same name with other candidates participating in different campaigns.

### Vote:
The Vote model represents an individual vote and are linled to a particular campaign and candidate. Through this relationship, votes can be retrieved within the scope of a specific candidate or campaign.

### Results:
The Results class is designed to encapsulate the logic for calculating the votes belonging to a campaign or candidate. It returns the amount of valid and invalid votes in a structured format that can be easily used by the front end to display results data.

The `calculate_votes` method can be implemented by any class that has a `has_many` association with votes. This means that voting results can calculated for any object that responds to the votes association regardless the class it belongs to.

## Program flow:
![program-flow](https://github.com/DanamiteGS/sms-voting/assets/91506697/2183eed5-7705-4313-a47c-646a77bf03d5)

## Import votes:

Since this is a Rails application, I decided to write the logic for importing votes inside a rake script in order to leverage the existing Rails framework, models, and database connections. The provided logs are read line by line and are saved into an array. This array is then processed in batches in order to maintain efficiency when working with large log data.

Votes can be imported by running the task with the file path of the logs:
```
rails votes:import path/to/logs.txt
```

If no file path is provided, the script will prompt the user to manually enter log data in the terminal:
```
rails votes:import
```
