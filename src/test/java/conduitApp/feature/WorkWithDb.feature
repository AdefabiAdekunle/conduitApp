
@ignore
Feature: work with DB

    Background: connect to db
        * def dbHandler = Java.type('helpers.Dbhandler')

    Scenario: Seed database with a new Job
        * eval dbHandler.addNewJobWithName("QA5")
    
    Scenario: Get level by Job
        * def level = dbHandler.getMinAndMaxLevelsForJob("QA5")
        * print level.min_lvl
        * print level.max_lvl
        # it is going to print out 80 and 120
        And match level.min_lvl == '80'
        And match level.max_lvl == '120'


