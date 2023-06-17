#@debug @parallel=false
Feature: Hooks

Background: hooks
    # Before Hooks
    # * def result = callonce read('classpath:helpers/Dummy.feature')
    # * def username = result.username
    
    # after hooks
    * configure afterScenario = function(){karate.call('classpath:helpers/Dummy.feature')}
    # with custome or inline JS code
    * configure afterFeature = 
    """
        function () {
            karate.log("After Feature Text")
        }
    """

    Scenario: First scenario
        # * print username
        * print " "
        * print 'This is first scenario'
    
    Scenario: Second Scenario
        # * print username
        * print " "
        * print 'This is second scenario'