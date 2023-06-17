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
    # * set articleRequestBody.article.title = jsonArticle.title
    # * set articleRequestBody.article.description = jsonArticle.description
    # using feeder file
    * set articleRequestBody.article.title = __gatling.Title
    * set articleRequestBody.article.description = __gatling.Description
    * set articleRequestBody.article.body = jsonArticle.body

    
   
Scenario: Create and  delete article 
    # without using environment global headers auth
    # Given header Authorization = 'Token ' + token
    # with custom feeder tokens
    * configure headers = {"Authorization": #("Token " + __gatling.token)}
    # * print __gatling.token
    Given path 'articles'
    # without reading from file
    # And request {"article": {"tagList": [],"title": "Delete Article","description": "test test","body": "body"}}
    # reading from file
    And request articleRequestBody
    # using name resolver to name each post article on gatling request
    And header karate-name = "Title request: " + __gatling.Title
    When method Post
    Then status 200
    * def articleId = response.article.slug

    # adding a user think/wait time before deleting an article
    * karate.pause(5000)

    # without using environment global headers auth
    # Given header Authorization = 'Token ' + token
    Given path 'articles',articleId
    When method Delete 
    Then status 204

   


    