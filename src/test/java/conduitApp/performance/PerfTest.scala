package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

import conduitApp.performance.createTokens.CreateTokens

class PerfTest extends Simulation {
   
   CreateTokens.createAccessTokens()
   
    val tokenFeeder = Iterator.continually (Map("token" -> CreateTokens.getNextToken()))

   val protocol = karateProtocol(
    // to make the delete request run only once we add the below path
    "/api/articles/{articleId}" -> Nil
  )

  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
//   protocol.runner.karateEnv("perf")

  val csvFeeder = csv("articles.csv").circular //Circular-> since we have three data values in csv and our user is more than 3


    // Without feeder
 // val createAndDeleteArticle = scenario("create and delete article").exec(karateFeature("classpath:conduitApp/performance/createAndDeleteArticle.feature"))

    // with Feeder
    val createAndDeleteArticle = scenario("create and delete article")
            .feed(csvFeeder)
            .feed(tokenFeeder)
            .exec(karateFeature("classpath:conduitApp/performance/createAndDeleteArticle.feature"))
  //Initial set up
//   setUp(
//     createAndDeleteArticle.inject(
//         atOnceUsers(3)
//         ).protocols(protocol)
//   )
  // setup fpr Simulation setup session
  setUp(
    createAndDeleteArticle.inject(
        atOnceUsers(1), //login for first user
        nothingFor(4 seconds), //We doing nothing for 4 seconds
        constantUsersPerSec(1) during (2 seconds) // One user every seconds withing time frame of 10 seconds
        // constantUsersPerSec(2) during (10 seconds), // users are now creating and deleting article
        // rampUsersPerSec(2) to 10 during (20 seconds), // with  more user using the app we incrase the the num of users from 2 to 10
        // nothingFor(5 seconds),
        // constantUsersPerSec(1) during (5 seconds)
        ).protocols(protocol)
  )

}