class Autogenerated {
  Geocoding? geocoding;
  String? type;
  List<Features>? features;
  List<double>? bbox;

  Autogenerated({this.geocoding, this.type, this.features, this.bbox});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    geocoding = json['geocoding'] != null
        ? new Geocoding.fromJson(json['geocoding'])
        : null;
    type = json['type'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
    bbox = json['bbox'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geocoding != null) {
      data['geocoding'] = this.geocoding!.toJson();
    }
    data['type'] = this.type;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    data['bbox'] = this.bbox;
    return data;
  }
}

class Geocoding {
  String? version;
  String? attribution;
  Query? query;
  Engine? engine;
  int? timestamp;

  Geocoding(
      {this.version,
      this.attribution,
      this.query,
      this.engine,
      this.timestamp});

  Geocoding.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    attribution = json['attribution'];
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
    engine =
        json['engine'] != null ? new Engine.fromJson(json['engine']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['attribution'] = this.attribution;
    if (this.query != null) {
      data['query'] = this.query!.toJson();
    }
    if (this.engine != null) {
      data['engine'] = this.engine!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Query {
  String? text;
  String? parser;
  ParsedText? parsedText;
  int? size;
  List<String>? layers;
  bool? private;
  List<String>? boundaryCountry;
  Lang? lang;
  int? querySize;

  Query(
      {this.text,
      this.parser,
      this.parsedText,
      this.size,
      this.layers,
      this.private,
      this.boundaryCountry,
      this.lang,
      this.querySize});

  Query.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    parser = json['parser'];
    parsedText = json['parsed_text'] != null
        ? new ParsedText.fromJson(json['parsed_text'])
        : null;
    size = json['size'];
    layers = json['layers'].cast<String>();
    private = json['private'];
    boundaryCountry = json['boundary.country'].cast<String>();
    lang = json['lang'] != null ? new Lang.fromJson(json['lang']) : null;
    querySize = json['querySize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['parser'] = this.parser;
    if (this.parsedText != null) {
      data['parsed_text'] = this.parsedText!.toJson();
    }
    data['size'] = this.size;
    data['layers'] = this.layers;
    data['private'] = this.private;
    data['boundary.country'] = this.boundaryCountry;
    if (this.lang != null) {
      data['lang'] = this.lang!.toJson();
    }
    data['querySize'] = this.querySize;
    return data;
  }
}

class ParsedText {
  String? subject;
  String? locality;

  ParsedText({this.subject, this.locality});

  ParsedText.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    locality = json['locality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['locality'] = this.locality;
    return data;
  }
}

class Lang {
  String? name;
  String? iso6391;
  String? iso6393;
  String? via;
  bool? defaulted;

  Lang({this.name, this.iso6391, this.iso6393, this.via, this.defaulted});

  Lang.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    iso6391 = json['iso6391'];
    iso6393 = json['iso6393'];
    via = json['via'];
    defaulted = json['defaulted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['iso6391'] = this.iso6391;
    data['iso6393'] = this.iso6393;
    data['via'] = this.via;
    data['defaulted'] = this.defaulted;
    return data;
  }
}

class Engine {
  String? name;
  String? author;
  String? version;

  Engine({this.name, this.author, this.version});

  Engine.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    author = json['author'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['author'] = this.author;
    data['version'] = this.version;
    return data;
  }
}

class Features {
  String? type;
  Geometry? geometry;
  Properties? properties;
  List<double>? bbox;

  Features({this.type, this.geometry, this.properties, this.bbox});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    bbox = json['bbox'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    data['bbox'] = this.bbox;
    return data;
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Properties {
  String? id;
  String? gid;
  String? layer;
  String? source;
  String? sourceId;
  String? name;
  String? accuracy;
  String? country;
  String? countryGid;
  String? countryA;
  String? region;
  String? regionGid;
  String? regionA;
  String? county;
  String? countyGid;
  String? locality;
  String? localityGid;
  String? continent;
  String? continentGid;
  String? label;
  Addendum? addendum;

  Properties(
      {this.id,
      this.gid,
      this.layer,
      this.source,
      this.sourceId,
      this.name,
      this.accuracy,
      this.country,
      this.countryGid,
      this.countryA,
      this.region,
      this.regionGid,
      this.regionA,
      this.county,
      this.countyGid,
      this.locality,
      this.localityGid,
      this.continent,
      this.continentGid,
      this.label,
      this.addendum});

  Properties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gid = json['gid'];
    layer = json['layer'];
    source = json['source'];
    sourceId = json['source_id'];
    name = json['name'];
    accuracy = json['accuracy'];
    country = json['country'];
    countryGid = json['country_gid'];
    countryA = json['country_a'];
    region = json['region'];
    regionGid = json['region_gid'];
    regionA = json['region_a'];
    county = json['county'];
    countyGid = json['county_gid'];
    locality = json['locality'];
    localityGid = json['locality_gid'];
    continent = json['continent'];
    continentGid = json['continent_gid'];
    label = json['label'];
    addendum = json['addendum'] != null
        ? new Addendum.fromJson(json['addendum'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gid'] = this.gid;
    data['layer'] = this.layer;
    data['source'] = this.source;
    data['source_id'] = this.sourceId;
    data['name'] = this.name;
    data['accuracy'] = this.accuracy;
    data['country'] = this.country;
    data['country_gid'] = this.countryGid;
    data['country_a'] = this.countryA;
    data['region'] = this.region;
    data['region_gid'] = this.regionGid;
    data['region_a'] = this.regionA;
    data['county'] = this.county;
    data['county_gid'] = this.countyGid;
    data['locality'] = this.locality;
    data['locality_gid'] = this.localityGid;
    data['continent'] = this.continent;
    data['continent_gid'] = this.continentGid;
    data['label'] = this.label;
    if (this.addendum != null) {
      data['addendum'] = this.addendum!.toJson();
    }
    return data;
  }
}

class Addendum {
  Concordances? concordances;
  Geonames? geonames;

  Addendum({this.concordances, this.geonames});

  Addendum.fromJson(Map<String, dynamic> json) {
    concordances = json['concordances'] != null
        ? new Concordances.fromJson(json['concordances'])
        : null;
    geonames = json['geonames'] != null
        ? new Geonames.fromJson(json['geonames'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.concordances != null) {
      data['concordances'] = this.concordances!.toJson();
    }
    if (this.geonames != null) {
      data['geonames'] = this.geonames!.toJson();
    }
    return data;
  }
}

class Concordances {
  int? gnId;
  int? gpId;
  int? qsPgId;
  String? wdId;
  String? wkPage;

  Concordances({this.gnId, this.gpId, this.qsPgId, this.wdId, this.wkPage});

  Concordances.fromJson(Map<String, dynamic> json) {
    gnId = json['gn:id'];
    gpId = json['gp:id'];
    qsPgId = json['qs_pg:id'];
    wdId = json['wd:id'];
    wkPage = json['wk:page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gn:id'] = this.gnId;
    data['gp:id'] = this.gpId;
    data['qs_pg:id'] = this.qsPgId;
    data['wd:id'] = this.wdId;
    data['wk:page'] = this.wkPage;
    return data;
  }
}

class Geonames {
  String? featureCode;

  Geonames({this.featureCode});

  Geonames.fromJson(Map<String, dynamic> json) {
    featureCode = json['feature_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feature_code'] = this.featureCode;
    return data;
  }
}
