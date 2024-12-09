class PropertyDetailsForm {
  final PropertyDetails propertyDetails;
  final LocalityDetails localityDetails;
  final SaleResaleDetails saleResaleDetails;
  final Gallery gallery;
  final Amenities amenities;
  final AdditionalInformation additionalInformation;
  final ExtraAmenities extraAmenities;

  PropertyDetailsForm({
    required this.propertyDetails,
    required this.localityDetails,
    required this.saleResaleDetails,
    required this.gallery,
    required this.amenities,
    required this.additionalInformation,
    required this.extraAmenities,
  });

  factory PropertyDetailsForm.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsForm(
      propertyDetails: PropertyDetails.fromJson(json['propertyDetails']),
      localityDetails: LocalityDetails.fromJson(json['localityDetails']),
      saleResaleDetails: SaleResaleDetails.fromJson(json['saleResaleDetails']),
      gallery: Gallery.fromJson(json['gallery']),
      amenities: Amenities.fromJson(json['amenities']),
      additionalInformation: AdditionalInformation.fromJson(json['additionalInformation']),
      extraAmenities: ExtraAmenities.fromJson(json['extraAmenities']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyDetails': propertyDetails.toJson(),
      'localityDetails': localityDetails.toJson(),
      'saleResaleDetails': saleResaleDetails.toJson(),
      'gallery': gallery.toJson(),
      'amenities': amenities.toJson(),
      'additionalInformation': additionalInformation.toJson(),
      'extraAmenities': extraAmenities.toJson(),
    };
  }
}

class PropertyDetails {
  final String propertyType;
  final String bhkType;
  final String propertyAge;
  final int carpetArea;
  final String totalFloor;
  final String ownershipType;
  final String facing;
  final int plotArea;

  PropertyDetails({
    required this.propertyType,
    required this.bhkType,
    required this.propertyAge,
    required this.carpetArea,
    required this.totalFloor,
    required this.ownershipType,
    required this.facing,
    required this.plotArea,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) {
    return PropertyDetails(
      propertyType: json['propertyType'],
      bhkType: json['bhkType'],
      propertyAge: json['propertyAge'],
      carpetArea: json['carpetArea'],
      totalFloor: json['totalFloor'],
      ownershipType: json['ownershipType'],
      facing: json['facing'],
      plotArea: json['plotArea'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyType': propertyType,
      'bhkType': bhkType,
      'propertyAge': propertyAge,
      'carpetArea': carpetArea,
      'totalFloor': totalFloor,
      'ownershipType': ownershipType,
      'facing': facing,
      'plotArea': plotArea,
    };
  }
}

class LocalityDetails {
  final String city;
  final String locality;
  final String streetArea;

  LocalityDetails({
    required this.city,
    required this.locality,
    required this.streetArea,
  });

  factory LocalityDetails.fromJson(Map<String, dynamic> json) {
    return LocalityDetails(
      city: json['city'],
      locality: json['locality'],
      streetArea: json['streetArea'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'locality': locality,
      'streetArea': streetArea,
    };
  }
}

class SaleResaleDetails {
  final int expectedPrice;
  final int maintenanceCost;
  final bool priceNegotiable;
  final bool currentlyUnderLoan;
  final String availableFrom;
  final String furnishing;
  final String parking;
  final String kitchenType;
  final String description;

  SaleResaleDetails({
    required this.expectedPrice,
    required this.maintenanceCost,
    required this.priceNegotiable,
    required this.currentlyUnderLoan,
    required this.availableFrom,
    required this.furnishing,
    required this.parking,
    required this.kitchenType,
    required this.description,
  });

  factory SaleResaleDetails.fromJson(Map<String, dynamic> json) {
    return SaleResaleDetails(
      expectedPrice: json['expectedPrice'],
      maintenanceCost: json['maintenanceCost'],
      priceNegotiable: json['priceNegotiable'],
      currentlyUnderLoan: json['currentlyUnderLoan'],
      availableFrom: json['availableFrom'],
      furnishing: json['furnishing'],
      parking: json['parking'],
      kitchenType: json['kitchenType'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expectedPrice': expectedPrice,
      'maintenanceCost': maintenanceCost,
      'priceNegotiable': priceNegotiable,
      'currentlyUnderLoan': currentlyUnderLoan,
      'availableFrom': availableFrom,
      'furnishing': furnishing,
      'parking': parking,
      'kitchenType': kitchenType,
      'description': description,
    };
  }
}

class Gallery {
  final List<String> images;

  Gallery({required this.images});

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(images: List<String>.from(json['images']));
  }

  Map<String, dynamic> toJson() {
    return {'images': images};
  }
}

class Amenities {
  final int bathrooms;
  final String waterSupply;
  final String gratedSecurity;
  final int balcony;
  final String internetService;

  Amenities({
    required this.bathrooms,
    required this.waterSupply,
    required this.gratedSecurity,
    required this.balcony,
    required this.internetService,
  });

  factory Amenities.fromJson(Map<String, dynamic> json) {
    return Amenities(
      bathrooms: json['bathrooms'],
      waterSupply: json['waterSupply'],
      gratedSecurity: json['gratedSecurity'],
      balcony: json['balcony'],
      internetService: json['internetService'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bathrooms': bathrooms,
      'waterSupply': waterSupply,
      'gratedSecurity': gratedSecurity,
      'balcony': balcony,
      'internetService': internetService,
    };
  }
}

class AdditionalInformation {
  final String khataCertificate;
  final String saleDeedCertificate;
  final String propertyTaxPaid;
  final String occupancyCertificate;

  AdditionalInformation({
    required this.khataCertificate,
    required this.saleDeedCertificate,
    required this.propertyTaxPaid,
    required this.occupancyCertificate,
  });

  factory AdditionalInformation.fromJson(Map<String, dynamic> json) {
    return AdditionalInformation(
      khataCertificate: json['khataCertificate'],
      saleDeedCertificate: json['saleDeedCertificate'],
      propertyTaxPaid: json['propertyTaxPaid'],
      occupancyCertificate: json['occupancyCertificate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'khataCertificate': khataCertificate,
      'saleDeedCertificate': saleDeedCertificate,
      'propertyTaxPaid': propertyTaxPaid,
      'occupancyCertificate': occupancyCertificate,
    };
  }
}

class ExtraAmenities {
  final List<String> amenitiesList;

  ExtraAmenities({required this.amenitiesList});

  factory ExtraAmenities.fromJson(Map<String, dynamic> json) {
    return ExtraAmenities(
      amenitiesList: List<String>.from(json['amenitiesList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'amenitiesList': amenitiesList};
  }
}
