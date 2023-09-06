class PageSchema {

  static String createPage = r'''
    mutation CreatePage(
      $user: ID!,
      $name: String!,
      $phoneNumber: String!,
      $email: String!,
      $cities: String!,
      $references: String!,
      $description: String!,
      $address: String,
    ){
      createPage(input:{
        user: $user,
        name: $name,
        phoneNumber: $phoneNumber,
        email: $email,
        cities: $cities,
        references: $references,
        description: $description,
        address: $address,
      }){
        success
        page{
          id
          name
          phoneNumber
          references
          email
          picture
          cover
          
        }
      }
    }
  ''';
}