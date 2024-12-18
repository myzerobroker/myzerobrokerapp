class PropertyInCityModel {
  dynamic success;
  List<Property>? properties;
  Pagination? pagination;
  dynamic cityName;
  dynamic areaName;
  dynamic propertyCount;

  PropertyInCityModel({
    required this.success,
    this.properties,
    this.pagination,
    this.cityName,
    this.areaName,
    this.propertyCount,
  });

  factory PropertyInCityModel.fromJson(Map<String, dynamic> json) {
    return PropertyInCityModel(
      success: json['success'],
      properties: (json['properties'] as List)
          .map((item) => Property.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
      cityName: json['city_name'],
      areaName: json['area_name'],
      propertyCount: json['property_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'properties': properties == null
          ? []
          : properties!.map((item) => item.toJson()).toList(),
      'pagination': pagination?.toJson(),
      'city_name': cityName,
      'area_name': areaName,
      'property_count': propertyCount,
    };
  }
}

class Property {
  dynamic id;
  dynamic userId;
  dynamic status;
  dynamic property;
  dynamic purpose;
  dynamic propertyType;
  dynamic propertyName;
  dynamic bhk;
  dynamic ownership;
  dynamic totalFloor;
  dynamic floor;
  dynamic photos;
  dynamic roomNo;
  dynamic facing;
  dynamic cityId;
  dynamic localityId;
  dynamic localityType;
  dynamic street;
  dynamic areaType;
  dynamic areaSqft;
  dynamic plotFront;
  dynamic plotDepth;
  dynamic frontRoad;
  dynamic sideRoad;
  dynamic carpetAreaSqft;
  dynamic propertyAge;
  dynamic furnishing;
  dynamic expectedPrice;
  dynamic expectedRent;
  dynamic priceNegotiable;
  dynamic underloan;
  dynamic deposit;
  dynamic parkingType;
  dynamic kitchenType;
  dynamic bathroom;
  dynamic balcony;
  dynamic waterSupply;
  dynamic powerBackupType;
  dynamic liftType;
  dynamic gratedSecurity;
  dynamic availability;
  dynamic startTime;
  dynamic endTime;
  dynamic description;
  dynamic maintenanceCost;
  dynamic availableFrom;
  dynamic mainRoad;
  dynamic cornerProperty;
  dynamic parking;
  dynamic secondaryNumber;
  dynamic previousOccupancy;
  dynamic whoWillShow;
  dynamic leaseYears;
  dynamic khataCert;
  dynamic deedCert;
  dynamic propertyTax;
  dynamic occupancyCert;
  dynamic maintainanceExtra;
  dynamic depositeNegotiable;
  dynamic bank;
  dynamic serviceCenter;
  dynamic showRoom;
  dynamic atm;
  dynamic retail;
  dynamic lift;
  dynamic internetService;
  dynamic airConditioner;
  dynamic clubHouse;
  dynamic intercom;
  dynamic swimmingPool;
  dynamic landmark; 
  dynamic childrensPlayArea;
  dynamic fireSafety;
  dynamic servantRoom;
  dynamic shoppingCenter;
  dynamic gasPipeline;
  dynamic park;
  dynamic rainWaterHarvesting;
  dynamic sewageTreatment;
  dynamic houseKeeping;
  dynamic powerBackup;
  dynamic visitorParking;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic isShortlisted;

  Property({
    this.id,
    this.userId,
    this.status,
    this.property,
    this.purpose,
    this.propertyType,
    this.propertyName,
    this.bhk,
    this.ownership,
    this.totalFloor,
    this.floor,
    this.photos,
    this.roomNo,
    this.facing,
    this.cityId,
    this.localityId,
    this.localityType,
    this.street,
    this.landmark,
    this.areaType,
    this.areaSqft,
    this.plotFront,
    this.plotDepth,
    this.frontRoad,
    this.sideRoad,
    this.carpetAreaSqft,
    this.propertyAge,
    this.furnishing,
    this.expectedPrice,
    this.expectedRent,
    this.priceNegotiable,
    this.underloan,
    this.deposit,
    this.parkingType,
    this.kitchenType,
    this.bathroom,
    this.balcony,
    this.waterSupply,
    this.powerBackupType,
    this.liftType,
    this.gratedSecurity,
    this.availability,
    this.startTime,
    this.endTime,
    this.description,
    this.maintenanceCost,
    this.availableFrom,
    this.mainRoad,
    this.cornerProperty,
    this.parking,
    this.secondaryNumber,
    this.previousOccupancy,
    this.whoWillShow,
    this.leaseYears,
    this.khataCert,
    this.deedCert,
    this.propertyTax,
    this.occupancyCert,
    this.maintainanceExtra,
    this.depositeNegotiable,
    this.bank,
    this.serviceCenter,
    this.showRoom,
    this.atm,
    this.retail,
    this.lift,
    this.internetService,
    this.airConditioner,
    this.clubHouse,
    this.intercom,
    this.swimmingPool,
    this.childrensPlayArea,
    this.fireSafety,
    this.servantRoom,
    this.shoppingCenter,
    this.gasPipeline,
    this.park,
    this.rainWaterHarvesting,
    this.sewageTreatment,
    this.houseKeeping,
    this.powerBackup,
    this.visitorParking,
    this.createdAt,
    this.updatedAt,
    this.isShortlisted,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      property: json['property'],
      purpose: json['purpose'],
      propertyType: json['property_type'],
      propertyName: json['property_name'],
      bhk: json['bhk'],
      ownership: json['ownership'],
      totalFloor: json['total_floor'],
      floor: json['floor'],
      photos: json['photos'],
      roomNo: json['room_no'],
      facing: json['facing'],
      cityId: json['city_id'],
      localityId: json['locality_id'],
      localityType: json['locality_type'],
      street: json['street'],
      landmark: json['landmark'],
      areaType: json['area_type'],
      areaSqft: json['area_sqft'],
      plotFront: json['plot_front'],
      plotDepth: json['plot_depth'],
      frontRoad: json['front_road'],
      sideRoad: json['side_road'],
      carpetAreaSqft: json['carpet_area_sqft'],
      propertyAge: json['property_age'],
      furnishing: json['furnishing'],
      expectedPrice: json['expected_price'],
      expectedRent: json['expected_rent'],
      priceNegotiable: json['price_negotiable'],
      underloan: json['underloan'],
      deposit: json['deposit'],
      parkingType: json['parking_type'],
      kitchenType: json['kitchen_type'],
      bathroom: json['bathroom'],
      balcony: json['balcony'],
      waterSupply: json['water_supply'],
      powerBackupType: json['power_backup_type'],
      liftType: json['lift_type'],
      gratedSecurity: json['grated_security'],
      availability: json['availability'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      description: json['description'],
      maintenanceCost: json['maintenance_cost'],
      availableFrom: json['available_from'],
      mainRoad: json['main_road'],
      cornerProperty: json['corner_property'],
      parking: json['parking'],
      secondaryNumber: json['secondary_number'],
      previousOccupancy: json['previous_occupancy'],
      whoWillShow: json['who_will_show'],
      leaseYears: json['lease_years'],
      khataCert: json['khata_cert'],
      deedCert: json['deed_cert'],
      propertyTax: json['property_tax'],
      occupancyCert: json['occupancy_cert'],
      maintainanceExtra: json['maintainance_extra'],
      depositeNegotiable: json['deposite_negotiable'],
      bank: json['bank'],
      serviceCenter: json['service_center'],
      showRoom: json['show_room'],
      atm: json['atm'],
      retail: json['retail'],
      lift: json['lift'],
      internetService: json['internet_service'],
      airConditioner: json['air_conditioner'],
      clubHouse: json['club_house'],
      intercom: json['intercom'],
      swimmingPool: json['swimming_pool'],
      childrensPlayArea: json['childrens_play_area'],
      fireSafety: json['fire_safety'],
      servantRoom: json['servant_room'],
      shoppingCenter: json['shopping_center'],
      gasPipeline: json['gas_pipeline'],
      park: json['park'],
      rainWaterHarvesting: json['rain_water_harvesting'],
      sewageTreatment: json['sewage_treatment'],
      houseKeeping: json['house_keeping'],
      powerBackup: json['power_backup'],
      visitorParking: json['visitor_parking'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isShortlisted: json['isShortlisted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'property': property,
      'purpose': purpose,
      'property_type': propertyType,
      'property_name': propertyName,
      'bhk': bhk,
      'ownership': ownership,
      'total_floor': totalFloor,
      'floor': floor,
      'photos': photos,
      'room_no': roomNo,
      'facing': facing,
      'city_id': cityId,
      'locality_id': localityId,
      'locality_type': localityType,
      'street': street,
      'landmark': landmark,
      'area_type': areaType,
      'area_sqft': areaSqft,
      'plot_front': plotFront,
      'plot_depth': plotDepth,
      'front_road': frontRoad,
      'side_road': sideRoad,
      'carpet_area_sqft': carpetAreaSqft,
      'property_age': propertyAge,
      'furnishing': furnishing,
      'expected_price': expectedPrice,
      'expected_rent': expectedRent,
      'price_negotiable': priceNegotiable,
      'underloan': underloan,
      'deposit': deposit,
      'parking_type': parkingType,
      'kitchen_type': kitchenType,
      'bathroom': bathroom,
      'balcony': balcony,
      'water_supply': waterSupply,
      'power_backup_type': powerBackupType,
      'lift_type': liftType,
      'grated_security': gratedSecurity,
      'availability': availability,
      'start_time': startTime,
      'end_time': endTime,
      'description': description,
      'maintenance_cost': maintenanceCost,
      'available_from': availableFrom,
      'main_road': mainRoad,
      'corner_property': cornerProperty,
      'parking': parking,
      'secondary_number': secondaryNumber,
      'previous_occupancy': previousOccupancy,
      'who_will_show': whoWillShow,
      'lease_years': leaseYears,
      'khata_cert': khataCert,
      'deed_cert': deedCert,
      'property_tax': propertyTax,
      'occupancy_cert': occupancyCert,
      'maintainance_extra': maintainanceExtra,
      'deposite_negotiable': depositeNegotiable,
      'bank': bank,
      'service_center': serviceCenter,
      'show_room': showRoom,
      'atm': atm,
      'retail': retail,
      'lift': lift,
      'internet_service': internetService,
      'air_conditioner': airConditioner,
      'club_house': clubHouse,
      'intercom': intercom,
      'swimming_pool': swimmingPool,
      'childrens_play_area': childrensPlayArea,
      'fire_safety': fireSafety,
      'servant_room': servantRoom,
      'shopping_center': shoppingCenter,
      'gas_pipeline': gasPipeline,
      'park': park,
      'rain_water_harvesting': rainWaterHarvesting,
      'sewage_treatment': sewageTreatment,
      'house_keeping': houseKeeping,
      'power_backup': powerBackup,
      'visitor_parking': visitorParking,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'isShortlisted': isShortlisted,
    };
  }
}

class Pagination {
  dynamic currentPage;
  dynamic lastPage;
  dynamic perPage;
  dynamic total;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}
