
Feature: Create Token

    Scenario: Create Token
        # Given url 'https://api.realworld.io/api/'
        # making use of the url as a global variable
        Given url apiUrl
        Given path 'users/login'
        # without using path variable
        # And request {"user": {"email": "adekunle@test.com","password": "Ikeoluwa_007"}}
        # Using path variable
        # And request {"user": {"email": "#(email)","password": "#(password)"}}
        # using environment global variable
        And request {"user": {"email": "#(userEmail)","password": "#(userPassword)"}}
        When method Post
        Then status 200
        * def authToken = response.user.token