// function fn() {
//   var env = karate.env; // get system property 'karate.env'
//   karate.log('karate.env system property was:', env);
//   if (!env) {
//     env = 'dev';
//   }
//   var config = {
//     env: env,
//     myVarName: 'someValue'
//   }
//   if (env == 'dev') {
//     // customize
//     // e.g. config.foo = 'bar';
//   } else if (env == 'e2e') {
//     // customize
//   }
//   return config;
// }
function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
   apiUrl: 'https://api.realworld.io/api/',
    myVarName: 'someValue'
  }
  if (env == 'dev') {
    config.userEmail = "adekunle@test.com"
    config.userPassword = "Ikeoluwa_007"
  } 
  if (env == 'qa') {
    config.userEmail = "adekunle1@test.com"
    config.userPassword = "Ikeoluwa_007"
  }

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature',config).authToken
  karate.configure('headers',{Authorization: 'Token ' + accessToken})
  return config;
}