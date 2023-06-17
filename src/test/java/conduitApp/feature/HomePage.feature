#@debug
Feature: Tests for the home page (url from the homepage url https://angular.realworld.io/  then go to network tags to copy the get url)
    
    Background: Define URL
        # Given url 'https://api.realworld.io/api/'
        # making use of the url as a global variable
        Given url apiUrl

    # @debug
    Scenario: Get all tags
        Given path 'tags'  
        When method Get
        Then status 200
        And match response.tags contains "introduction"
        And match response.tags contains ["welcome","introduction"]
        And match response.tags !contains "baby"
        # only "introduction" is inside our tags so the assertion is true
        And match response.tags contains any ["a","b","introduction"]
        And match response.tags == "#array"
        And match each response.tags == "#string"
    # @skipme  
    Scenario: Get 10 articles from the page
        Given path "articles"
        Given params { limit: 10, offset: 0}
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        #And match response.articlesCount == 203
        And match response.articlesCount == "#number"
        And match response.articlesCount != 100
        #And match response == { articles:"#array", articlesCount: 203}
        And match response == { articles:"#array", articlesCount: "#number"}
        And match response.articles[0].createdAt contains '2023'
        # At least one article has one favourite acct
        #And match response.articles[*].favoritesCount contains 1034
        # At least one of the bio is null
        And match response.articles[*].author.bio contains null
        # OR
        And match response..bio contains null
        #For each Author the following is false
        And match each response..following == false
        # some fuzzy matching
        And match each response..following == "#boolean"
        And match each response..favoritesCount == "#number"
        # with a double tag, it means we expecting null or string
        And match each response..bio == "##string"
        ##3 some schema validation
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        And match each response.articles ==
        """
            {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": '#? timeValidator(_)',
            "updatedAt": '#? timeValidator(_)',
            "favorited": "#boolean",
            "favoritesCount": "#number",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            }
        }
        """

    @debug
    Scenario: Conditional logic
        Given path "articles"
        Given params { limit: 10, offset: 0}
        When method Get
        Then status 200
        * def favoritesCount = response.articles[0].favoritesCount
        * def article = response.articles[0]
       

        #* if (favoritesCount == 0) karate.call('classpath:helpers/AddLikes.feature',article)
        * def addCount = favoritesCount == 0 ? karate.call('classpath:helpers/AddLikes.feature', article).likesCount : favoritesCount

       
        Given path "articles"
        Given params { limit: 10, offset: 0}
        When method Get
        Then status 200
        And match response.articles[0].favoritesCount == addCount

    
    # @ignore
    # Scenario: Retry call
    #     * configure retry = {count:10, interval:5000}
    #     Given path "articles"
    #     Given params { limit: 10, offset: 0}
    #     # The retry goes on 10 times until favoritesCount equals to 1
    #     And retry until response.articles[0].favoritesCount == 1
    #     When method Get
    #     Then status 200

   
    Scenario: Sleep call
        * def sleep = function(pause){java.lang.Thread.sleep(pause)}
        Given path "articles"
        Given params { limit: 10, offset: 0}
        When method Get
        * eval sleep(10000)
        Then status 200

   
    Scenario: Number to String
        * def foo = 10
        * def json = {"bar": "#(foo + '')"}
        * match json == {"bar" : "10"}
    @debug
    Scenario: String to Number
        * def foo = "10"
        # first option
        * def json1 = {"bar": "#(foo * 1)"}
        # second option Note without ~~ it is double if not it is int
        * def json2 = {"bar" : "#(~~parseInt(foo))"}
        * match json1 == {"bar" : 10}
        * match json2 == {"bar" : 10}
