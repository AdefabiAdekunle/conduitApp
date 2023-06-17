
#@ignore
Feature: Sign Up new user

Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    Given url apiUrl


@debug
Scenario: New user Sign up
    # without using Data generator
    Given def userData = {"email": "adekunle8@test.com", "username": "Adekunle8"}

    # using data Generator
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()

    # assuming our DataGenerator Class methods is not static
    * def jsFunction = 
    """
        function () {
            var DataGenerator = Java.type('helpers.DataGenerator')
            var generator = new DataGenerator()
            return generator.getRandomUsername2()
        }
    """
    * def randomUsername2 = call jsFunction


    Given path 'users'
    And request 
    """
        {
            "user": {
                "email": '#(randomEmail)',
                "password": "Ikeoluwa_008",
                "username": "#(randomUsername)"
            }
        }
    """
    When method Post 
    Then status 200
    And match response ==
    """
    {
        "user": {
            "email": "#string",
            "username": "#string",
            "bio": "##string",
            "image": "#string",
            "token": "#string"
        }
    }
    """ 
# Data-Driven scenario
 #@debug
Scenario Outline: Validate Sign Up error messages
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()
    Given path 'users'
    And request 
    """
        {
            "user": {
                "email": '<email>',
                "password": "<password>",
                "username": "<username>"
            }
        }
    """
    When method Post 
    Then status 422
    And match response == <errorResponse>

    Examples: 
        | email              | password     | username                  | errorResponse                                                                             |
        | #(randomEmail)     | Ikeoluwa_007 | Adekunle1                 |  {"errors":{"username":["has already been taken"]}}                                       |
        | adekunle1@test.com | Ikeoluwa_007 | #(randomUsername)         |  {"errors":{"email":["has already been taken"]}}                                          |
        #|  adekunle1         | Ikeoluwa_007 | #(randomUsername)         |  {"errors": {"email": ["is invalid"]}}                                                    |
        #| #(randomEmail)     | Ikeoluwa_007 | Adekunle123123123123123   |  {"errors": {"username": ["is too long (maximum is 20 characters)"]}}                     |
        #| #(randomEmail)     |  Ike         | #(randomUsername)         |  {"errors": {"password": ["is too short (minimum is 8 characters)"]}}                     |
        |                    | Ikeoluwa_007 | #(randomUsername)         |  {"errors": {"email": ["can't be blank"]}}                                                |
        | #(randomEmail)     |              | #(randomUsername)         |  {"errors": {"password": ["can't be blank"]}}                                             |
        | #(randomEmail)     | Ikeoluwa_007 |                           |  {"errors": {"username" : ["can't be blank"]}}                                            |