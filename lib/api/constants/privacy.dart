import 'package:hostmi/api/models/faq_model.dart';

final List<FaqModel> privacyPolicies = [
  const FaqModel(
    question: "Partage de données personnelles",
    answer:
        "L’application HostMI s'engage à garantir la confidentialité des données personnelles utilisées par votre application. HostMI s'interdit également de communiquer à des partenaires des données personnelles sans vous en informer et sans vous offrir la possibilité d'exercer votre droit d'opposition. HostMI ne partage ni ne vend des données personnelles à des tiers.",
  ),
  const FaqModel(
    question: "Protection des données personnelles",
    answer:
        "L’application HostMI utilise vos données personnelles pour vous authentifier, vous fournir des services et, le cas échéant, vous proposer des offres adaptées à vos besoins. HostMI peut utiliser vos données personnelles, préalablement anonymisées de manière irréversible, à des fins d'analyse statistique.",
  ),
  const FaqModel(
    question:
        "Collecte des informations d'utilisation pour l'analyse statistique",
    answer:
        "L'application HostMI collecte des informations concernant l'utilisation de l'application et nous envoie ces informations pour analyse statistique afin d'améliorer encore l'application et le service associé. Toutes les informations collectées sont totalement anonymes et ne sont pas associées à l'utilisateur. Ces informations sont collectées et traitées conformément aux lois applicables. Il ne sera pas utilisé à d'autres fins que l'amélioration de l'application et du service associé. Aucune donnée personnelle n'est collectée. Si vous ne souhaitez pas que des données d'utilisation soient collectées, vous pouvez désactiver l’option, à tout moment, en vous rendant dans le menu des paramètres de l'application.",
  ),
  const FaqModel(
      question: "Conservation des données personnelles",
      answer:
          "L’application HostMI ne conserve pas vos données personnelles plus longtemps que nécessaire ou plus longtemps que prévu par la loi."),
  const FaqModel(
    question: "Quelles données personnelles sont traitées ?",
    answer:
        "L’application HostMI récupère et traite le numéro de téléphone pour vous reconnaître en tant que client HostMI éligible afin de vous fournir toutes les informations relatives à vos choix et vous proposer des offres et des services adaptés. De plus, l'application HostMI met à disposition une fonction de localisation (par GPS) afin de pouvoir vous proposez les maisons disponibles en fonction de cela. Une notice d'information est affichée pour avertir l’utilisateur lors de l'accès à la fonction de localisation et le consentement exprès de celui-ci est requis avant toute localisation.",
  ),
];
