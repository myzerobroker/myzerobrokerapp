// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Property {
  final String? userId;
  final String? status;
  final String? propertyType;
  final String? propertyName;
  final String? bhk;
  final String? ownership;
  final int? totalFloor;
  final int? floor;
  final String? roomNo;
  final String? facing;
  final String? cityId;
  final List<String>? photos;
  final String? localityId;
  final String? localityType;
  final String? street;
  final String? landmark;
  final String? areaType;
  final double? areaSqft;
  final double? plotFront;
  final double? plotDepth;
  final double? frontRoad;
  final double? sideRoad;
  final double? carpetAreaSqft;
  final String? propertyAge;
  final String? furnishing;
  final double? expectedPrice;
  final double? expectedRent;
  final bool? priceNegotiable;
  final bool? underLoan;
  final double? deposit;
  final String? parkingType;
  final String? kitchenType;
  final int? bathroom;
  final int? balcony;
  final String? waterSupply;
  final String? powerBackupType;
  final String? liftType;
  final bool? gratedSecurity;
  final String? availability;
  final String? startTime;
  final String? endTime;
  final String? description;
  final double? maintenanceCost;
  final String? availableFrom;
  final String? idealFor;
  final String? parking;
  final String? secondaryNumber;
  final String? previousOccupancy;
  final String? whoWillShow;
  final int? leaseYears;
  final bool? khataCert;
  final bool? deedCert;
  final bool? propertyTax;
  final bool? occupancyCert;
  final bool? lift;
  final bool? mainRoad;
  final bool? cornerProperty;
  final bool? maintenanceExtra;
  final bool? depositNegotiable;
  final bool? bank;
  final bool? serviceCenter;
  final bool? showRoom;
  final bool? atm;
  final bool? retail;
  final bool? internetService;
  final bool? airConditioner;
  final bool? clubHouse;
  final bool? intercom;
  final bool? swimmingPool;
  final bool? childrensPlayArea;
  final bool? fireSafety;
  final bool? servantRoom;
  final bool? shoppingCenter;
  final bool? gasPipeline;
  final bool? park;
  final bool? rainWaterHarvesting;
  final bool? sewageTreatment;
  final bool? houseKeeping;
  final bool? powerBackup;
  final bool? visitorParking;

  Property({
    this.userId,
    this.status,
    this.propertyType,
    this.propertyName,
    this.bhk,
    this.ownership,
    this.totalFloor,
    this.floor,
    this.roomNo,
    this.facing,
    this.cityId,
    this.photos,
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
    this.underLoan,
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
    this.idealFor,
    this.parking,
    this.secondaryNumber,
    this.previousOccupancy,
    this.whoWillShow,
    this.leaseYears,
    this.khataCert,
    this.deedCert,
    this.propertyTax,
    this.occupancyCert,
    this.lift,
    this.mainRoad,
    this.cornerProperty,
    this.maintenanceExtra,
    this.depositNegotiable,
    this.bank,
    this.serviceCenter,
    this.showRoom,
    this.atm,
    this.retail,
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
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'status': status,
      'propertyType': propertyType,
      'propertyName': propertyName,
      'bhk': bhk,
      'ownership': ownership,
      'totalFloor': totalFloor,
      'floor': floor,
      'roomNo': roomNo,
      'facing': facing,
      'cityId': cityId,
      'photos': photos,
      'localityId': localityId,
      'localityType': localityType,
      'street': street,
      'landmark': landmark,
      'areaType': areaType,
      'areaSqft': areaSqft,
      'plotFront': plotFront,
      'plotDepth': plotDepth,
      'frontRoad': frontRoad,
      'sideRoad': sideRoad,
      'carpetAreaSqft': carpetAreaSqft,
      'propertyAge': propertyAge,
      'furnishing': furnishing,
      'expectedPrice': expectedPrice,
      'expectedRent': expectedRent,
      'priceNegotiable': priceNegotiable,
      'underLoan': underLoan,
      'deposit': deposit,
      'parkingType': parkingType,
      'kitchenType': kitchenType,
      'bathroom': bathroom,
      'balcony': balcony,
      'waterSupply': waterSupply,
      'powerBackupType': powerBackupType,
      'liftType': liftType,
      'gratedSecurity': gratedSecurity,
      'availability': availability,
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
      'maintenanceCost': maintenanceCost,
      'availableFrom': availableFrom,
      'idealFor': idealFor,
      'parking': parking,
      'secondaryNumber': secondaryNumber,
      'previousOccupancy': previousOccupancy,
      'whoWillShow': whoWillShow,
      'leaseYears': leaseYears,
      'khataCert': khataCert,
      'deedCert': deedCert,
      'propertyTax': propertyTax,
      'occupancyCert': occupancyCert,
      'lift': lift,
      'mainRoad': mainRoad,
      'cornerProperty': cornerProperty,
      'maintenanceExtra': maintenanceExtra,
      'depositNegotiable': depositNegotiable,
      'bank': bank,
      'serviceCenter': serviceCenter,
      'showRoom': showRoom,
      'atm': atm,
      'retail': retail,
      'internetService': internetService,
      'airConditioner': airConditioner,
      'clubHouse': clubHouse,
      'intercom': intercom,
      'swimmingPool': swimmingPool,
      'childrensPlayArea': childrensPlayArea,
      'fireSafety': fireSafety,
      'servantRoom': servantRoom,
      'shoppingCenter': shoppingCenter,
      'gasPipeline': gasPipeline,
      'park': park,
      'rainWaterHarvesting': rainWaterHarvesting,
      'sewageTreatment': sewageTreatment,
      'houseKeeping': houseKeeping,
      'powerBackup': powerBackup,
      'visitorParking': visitorParking,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      userId: map['userId'],
      status: map['status'],
      propertyType: map['propertyType'],
      propertyName: map['propertyName'],
      bhk: map['bhk'],
      ownership: map['ownership'],
      totalFloor: map['totalFloor'],
      floor: map['floor'],
      roomNo: map['roomNo'],
      facing: map['facing'],
      cityId: map['cityId'],
      photos: map['photos'] != null ? List<String>.from(map['photos']) : null,
      localityId: map['localityId'],
      localityType: map['localityType'],
      street: map['street'],
      landmark: map['landmark'],
      areaType: map['areaType'],
      areaSqft: map['areaSqft']?.toDouble(),
      plotFront: map['plotFront']?.toDouble(),
      plotDepth: map['plotDepth']?.toDouble(),
      frontRoad: map['frontRoad']?.toDouble(),
      sideRoad: map['sideRoad']?.toDouble(),
      carpetAreaSqft: map['carpetAreaSqft']?.toDouble(),
      propertyAge: map['propertyAge'],
      furnishing: map['furnishing'],
      expectedPrice: map['expectedPrice']?.toDouble(),
      expectedRent: map['expectedRent']?.toDouble(),
      priceNegotiable: map['priceNegotiable'],
      underLoan: map['underLoan'],
      deposit: map['deposit']?.toDouble(),
      parkingType: map['parkingType'],
      kitchenType: map['kitchenType'],
      bathroom: map['bathroom'],
      balcony: map['balcony'],
      waterSupply: map['waterSupply'],
      powerBackupType: map['powerBackupType'],
      liftType: map['liftType'],
      gratedSecurity: map['gratedSecurity'],
      availability: map['availability'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      description: map['description'],
      maintenanceCost: map['maintenanceCost']?.toDouble(),
      availableFrom: map['availableFrom'],
      idealFor: map['idealFor'],
      parking: map['parking'],
      secondaryNumber: map['secondaryNumber'],
      previousOccupancy: map['previousOccupancy'],
      whoWillShow: map['whoWillShow'],
      leaseYears: map['leaseYears'],
      khataCert: map['khataCert'],
      deedCert: map['deedCert'],
      propertyTax: map['propertyTax'],
      occupancyCert: map['occupancyCert'],
      lift: map['lift'],
      mainRoad: map['mainRoad'],
      cornerProperty: map['cornerProperty'],
      maintenanceExtra: map['maintenanceExtra'],
      depositNegotiable: map['depositNegotiable'],
      bank: map['bank'],
      serviceCenter: map['serviceCenter'],
      showRoom: map['showRoom'],
      atm: map['atm'],
      retail: map['retail'],
      internetService: map['internetService'],
      airConditioner: map['airConditioner'],
      clubHouse: map['clubHouse'],
      intercom: map['intercom'],
      swimmingPool: map['swimmingPool'],
      childrensPlayArea: map['childrensPlayArea'],
      fireSafety: map['fireSafety'],
      servantRoom: map['servantRoom'],
      shoppingCenter: map['shoppingCenter'],
      gasPipeline: map['gasPipeline'],
      park: map['park'],
      rainWaterHarvesting: map['rainWaterHarvesting'],
      sewageTreatment: map['sewageTreatment'],
      houseKeeping: map['houseKeeping'],
      powerBackup: map['powerBackup'],
      visitorParking: map['visitorParking'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Property.fromJson(String source) =>
      Property.fromMap(json.decode(source));
}
