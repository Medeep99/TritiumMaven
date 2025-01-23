import 'package:maven/common/common.dart';

enum WeightUnit {
  kilogram,
  pound;
  

  String get name {
    return toString().split('.').last.capitalize;
  }

  String get abbreviated {
    switch (this) {
      case WeightUnit.kilogram:
        return 'kg';
      case WeightUnit.pound:
        return 'lb';
      
    }
  }
}