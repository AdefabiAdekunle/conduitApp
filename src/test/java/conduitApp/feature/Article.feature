Feature: Post Articles

    Background: Define URL
        # Given url 'https://api.realworld.io/api/'
        # making use of the url as a global variable
        Given url apiUrl
        # Given path 'users/login'
        # And request {"user": {"email": "adekunle@test.com","password": "Ikeoluwa_007"}}
        # When method Post
        # Then status 200
        # * def token = response.user.token
        # call everytime before each scenario
        #* def tokenResponse =  call read('classpath:helpers/CreateToken.feature') 
        # call once foe each scenario and without using path variable
        # * def tokenResponse =  callonce read('classpath:helpers/CreateToken.feature')
        # call once foe each scenario and Using path variable
        # * def tokenResponse =  callonce read('classpath:helpers/CreateToken.feature')  {"email": "adekunle@test.com","password": "Ikeoluwa_007"}
        # using environment global variable without global headers auth
        # * def tokenResponse =  callonce read('classpath:helpers/CreateToken.feature') 
        # * def token = tokenResponse.authToken

        * def articleRequestBody = read("classpath:conduitApp/json/newArticleRequest.json")
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def jsonArticle = dataGenerator.getRandomArticleValues()
        * set articleRequestBody.article.title = jsonArticle.title
        * set articleRequestBody.article.description = jsonArticle.description
        * set articleRequestBody.article.body = jsonArticle.body
       

        #@debug
    Scenario: Create a new article ()
        # without using environment global headers auth
        # Given header Authorization = 'Token ' + token
        Given path 'articles'
        # without reading from file
        # And request {"article": {"tagList": [],"title": "Bla Bla5","description": "test test","body": "body"}}
        # reading from file
        And request articleRequestBody
        When method Post
        Then status 200
        And match response.article.title == articleRequestBody.article.title

    @articleDelete
    Scenario: Create, confirm if succesfully created , delete article and confirm if succesfully deleted
        # without using environment global headers auth
        # Given header Authorization = 'Token ' + token
        Given path 'articles'
        # without reading from file
        # And request {"article": {"tagList": [],"title": "Delete Article","description": "test test","body": "body"}}
        # reading from file
        And request articleRequestBody
        When method Post
        Then status 200
        * def articleId = response.article.slug

        Given path 'articles',articleId
        When method Get
        Then status 200
        And match response.article.title == articleRequestBody.article.title


        # without using environment global headers auth
        # Given header Authorization = 'Token ' + token
        Given path 'articles',articleId
        When method Delete 
        Then status 204

        Given path 'articles',articleId
        When method Get
        Then status 404
        And match response.errors.article[0] == "not found"


        