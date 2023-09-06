class AuthenticationSchema {

  static String sendOTP = r'''
    mutation SendOTP(
      $phoneNumber: String!
    ){
      sendOtp(
        phoneNumber: $phoneNumber,
      ){
        success
      }
    }
  ''';

  static String phoneLogin = r'''
    mutation PhoneLogin(
      $phoneNumber: String!,
      $code: String!
    ){
      phoneLogin(
        phoneNumber: $phoneNumber,
        code:$code,
      ){
        success
        user{
          username
          phoneNumber
          dateJoined
        }
        token
        refreshToken
      }
    }
  ''';
}
