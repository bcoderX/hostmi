class HouseModel {
  HouseModel(
      {this.isAvailable,
      this.hasWater,
      this.hasCurrent,
      this.hasPool,
      this.mainImage,
      this.price,
      this.beds,
      this.bathrooms,
      this.address,
      this.sector,
      this.city,
      this.country,
      this.longitude,
      this.latitude,
      this.stars,
      this.isFavorite
      });
  final String? mainImage;
  final int? price;
  final int? beds;
  final int? bathrooms;
  final String? address;
  final String? sector;
  final String? city;
  final String? country;
  final double? longitude;
  final double? latitude;
  final int? stars;
  final bool? isFavorite;
  final bool? isAvailable;
  final bool? hasWater;
  final bool? hasCurrent;
  final bool? hasPool;
}
