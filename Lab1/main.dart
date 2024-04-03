/// Represents the composition and combustion calculations for a specific fuel.
/// This class is immutable and provides methods to calculate dry mass, combustible mass,
/// and lower heat value of combustion in different states.
class FuelData {
  final double hydrogen;
  final double carbon;
  final double sulfur;
  final double nitrogen;
  final double oxygen;
  final double water;
  final double ash;

  const FuelData({
    required this.hydrogen,
    required this.carbon,
    required this.sulfur,
    required this.nitrogen,
    required this.oxygen,
    required this.water,
    required this.ash,
  }) : assert(hydrogen + carbon + sulfur + nitrogen + oxygen + water + ash <= 100.0,
  'The sum of components must not exceed 100%.');

  /// Calculates the dry mass percentage.
  double calculateDryMass() => 100 - water - ash;

  /// Calculates the combustible mass percentage.
  double calculateCombustibleMass() => calculateDryMass() - (oxygen + nitrogen + sulfur);

  /// Calculates lower heat of combustion for the fuel in different mass states.
  Map<String, double> calculateLowerHeatCombustion() {
    const double cH = 339;  // Carbon to Heat value constant
    const double hH = 1030; // Hydrogen to Heat value constant
    const double oH = 108;  // Oxygen to Heat value constant
    const double sH = 25;   // Sulphur to Heat value constant

    double lhvAsReceived = cH * carbon + hH * hydrogen - oH * (oxygen - sulfur) - sH * water;
    double lhvDry = lhvAsReceived / (1 - water / 100);
    double lhvCombustible = lhvAsReceived / ((1 - water / 100) - (ash / 100));

    return {
      'asReceived': lhvAsReceived,
      'dry': lhvDry,
      'combustible': lhvCombustible,
    };
  }
}

void main() {
  const fuelData = FuelData(
    hydrogen: 3.2,
    carbon: 54.4,
    sulfur: 2.3,
    nitrogen: 1.0,
    oxygen: 3.1,
    water: 20.0,
    ash: 16.0,
  );

  var combustionValues = fuelData.calculateLowerHeatCombustion();

  print('Dry Mass: ${fuelData.calculateDryMass().toStringAsFixed(2)}%');
  print('Combustible Mass: ${fuelData.calculateCombustibleMass().toStringAsFixed(2)}%');
  print('Lower Heat Value (As Received): ${combustionValues['asReceived']?.toStringAsFixed(2) ?? 'N/A'} MJ/kg');
  print('Lower Heat Value (Dry): ${combustionValues['dry']?.toStringAsFixed(2) ?? 'N/A'} MJ/kg');
  print('Lower Heat Value (Combustible): ${combustionValues['combustible']?.toStringAsFixed(2) ?? 'N/A'} MJ/kg');
}
