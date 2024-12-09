class PropertyDetailsForm {
  final PropertyDetails? propertyDetails;
  final LocalityDetails? localityDetails;
  final SaleResaleDetails? saleResaleDetails;
  final Gallery? gallery;
  final Amenities? amenities;
  final AdditionalInformation? additionalInformation;
  final ExtraAmenities? extraAmenities;

  PropertyDetailsForm({
    this.propertyDetails,
    this.localityDetails,
    this.saleResaleDetails,
    this.gallery,
    this.amenities,
    this.additionalInformation,
    this.extraAmenities,
  });

  factory PropertyDetailsForm.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsForm(
      propertyDetails: json['propertyDetails'] != null
          ? PropertyDetails.fromJson(json['propertyDetails'])
          : null,
      localityDetails: json['localityDetails'] != null
          ? LocalityDetails.fromJson(json['localityDetails'])
          : null,
      saleResaleDetails: json['saleResaleDetails'] != null
          ? SaleResaleDetails.fromJson(json['saleResaleDetails'])
          : null,
      gallery:
          json['gallery'] != null ? Gallery.fromJson(json['gallery']) : null,
      amenities: json['amenities'] != null
          ? Amenities.fromJson(json['amenities'])
          : null,
      additionalInformation: json['additionalInformation'] != null
          ? AdditionalInformation.fromJson(json['additionalInformation'])
          : null,
      extraAmenities: json['extraAmenities'] != null
          ? ExtraAmenities.fromJson(json['extraAmenities'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (propertyDetails != null) 'propertyDetails': propertyDetails!.toJson(),
      if (localityDetails != null) 'localityDetails': localityDetails!.toJson(),
      if (saleResaleDetails != null)
        'saleResaleDetails': saleResaleDetails!.toJson(),
      if (gallery != null) 'gallery': gallery!.toJson(),
      if (amenities != null) 'amenities': amenities!.toJson(),
      if (additionalInformation != null)
        'additionalInformation': additionalInformation!.toJson(),
      if (extraAmenities != null) 'extraAmenities': extraAmenities!.toJson(),
    };
  }
}

class PropertyDetails {
  final String? propertyType;
  final String? bhkType;
  final String? propertyAge;
  final int? carpetArea;
  final String? totalFloor;
  final String? ownershipType;
  final String? facing;
  final int? plotArea;

  PropertyDetails({
    this.propertyType,
    this.bhkType,
    this.propertyAge,
    this.carpetArea,
    this.totalFloor,
    this.ownershipType,
    this.facing,
    this.plotArea,
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
  final String? city;
  final String? locality;
  final String? streetArea;

  LocalityDetails({
    this.city,
    this.locality,
    this.streetArea,
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
  final int? expectedPrice;
  final int? maintenanceCost;
  final bool? priceNegotiable;
  final bool? currentlyUnderLoan;
  final String? availableFrom;
  final String? furnishing;
  final String? parking;
  final String? kitchenType;
  final String? description;

  SaleResaleDetails({
    this.expectedPrice,
    this.maintenanceCost,
    this.priceNegotiable,
    this.currentlyUnderLoan,
    this.availableFrom,
    this.furnishing,
    this.parking,
    this.kitchenType,
    this.description,
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
  final List<String>? images;

  Gallery({this.images});

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
        images:
            json['images'] != null ? List<String>.from(json['images']) : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'images': images,
    };
  }
}

class Amenities {
  final int? bathrooms;
  final String? waterSupply;
  final String? gratedSecurity;
  final int? balcony;
  final String? internetService;

  Amenities({
    this.bathrooms,
    this.waterSupply,
    this.gratedSecurity,
    this.balcony,
    this.internetService,
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
  final String? khataCertificate;
  final String? saleDeedCertificate;
  final String? propertyTaxPaid;
  final String? occupancyCertificate;

  AdditionalInformation({
    this.khataCertificate,
    this.saleDeedCertificate,
    this.propertyTaxPaid,
    this.occupancyCertificate,
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
  final List<String>? amenitiesList;

  ExtraAmenities({this.amenitiesList});

  factory ExtraAmenities.fromJson(Map<String, dynamic> json) {
    return ExtraAmenities(
      amenitiesList: json['amenitiesList'] != null
          ? List<String>.from(json['amenitiesList'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amenitiesList': amenitiesList,
    };
  }
}
