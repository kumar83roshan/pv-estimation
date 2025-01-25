class EstimationService {
  /// Returns the material factor based on the Material of Construction (MOC)
  double getMaterialFactor(String material) {
    switch (material.toLowerCase()) {
      case "carbon steel":
        return 1.0; // Base factor
      case "stainless steel":
        return 1.2; // 20% more time
      case "duplex stainless steel": // DSS
        return 1.3; // 30% more time
      case "low temperature carbon steel": // LTCS
        return 1.1; // 10% more time
      case "low alloy steel":
        return 1.15; // 15% more time
      default:
        throw ArgumentError("Invalid material: $material");
    }
  }

  /// Cutting & Rolling Time (T1)
  double calculateCuttingAndRollingTime(double thickness, double diameter,
      double length) {
    double baseTime = 0;

    if (thickness >= 10 && thickness <= 16) {
      if (diameter <= 1000) {
        baseTime = 1;
      } else if (diameter <= 2500) {
        baseTime = 1.5;
      } else if (diameter <= 3500) {
        baseTime = 2;
      } else {
        baseTime = 3;
      }
    } else if (thickness >= 17 && thickness <= 25) {
      if (diameter <= 1000) {
        baseTime = 1.5;
      } else if (diameter <= 2500) {
        baseTime = 2;
      } else if (diameter <= 3500) {
        baseTime = 3;
      } else {
        baseTime = 3.5;
      }
    } else if (thickness >= 26 && thickness <= 50) {
      if (diameter <= 2500) {
        baseTime = 2;
      } else if (diameter <= 3500) {
        baseTime = 2.5;
      } else {
        baseTime = 3;
      }
    } else if (thickness >= 51 && thickness <= 75) {
      if (diameter <= 2500) {
        baseTime = 3;
      } else if (diameter <= 3500) {
        baseTime = 3.5;
      } else {
        baseTime = 4;
      }
    } else if (thickness > 75) {
      if (diameter <= 2500) {
        baseTime = 3.5;
      } else if (diameter <= 3500) {
        baseTime = 4;
      } else {
        baseTime = 4.5;
      }
    }

    // Scale by length
    return baseTime * (length / 2500);
  }

  /// Long Seam Welding Time (T2)
  double calculateLongSeamWeldingTime(double thickness, double diameter,
      double length) {
    double baseTime = 0;

    if (thickness >= 10 && thickness <= 16) {
      if (diameter <= 2500) {
        baseTime = 1.5;
      } else if (diameter <= 3500) {
        baseTime = 2;
      } else {
        baseTime = 2.5;
      }
    } else if (thickness >= 17 && thickness <= 25) {
      if (diameter <= 1000) {
        baseTime = 1;
      } else if (diameter <= 2500) {
        baseTime = 2;
      } else if (diameter <= 3500) {
        baseTime = 2.5;
      } else {
        baseTime = 3;
      }
    } else if (thickness >= 26 && thickness <= 50) {
      if (diameter <= 2500) {
        baseTime = 3.5;
      } else if (diameter <= 3500) {
        baseTime = 4;
      } else {
        baseTime = 4.5;
      }
    } else if (thickness >= 51 && thickness <= 75) {
      if (diameter <= 2500) {
        baseTime = 4;
      } else if (diameter <= 3500) {
        baseTime = 5;
      } else {
        baseTime = 6.5;
      }
    } else if (thickness > 75) {
      if (diameter <= 2500) {
        baseTime = 5;
      } else if (diameter <= 3500) {
        baseTime = 5.5;
      } else {
        baseTime = 7;
      }
    }

    // Scale by length
    return baseTime * (length / 2500);
  }

  /// Circumferential Seam Welding Time (T3)
  double calculateCircumferentialSeamTime(double thickness, double diameter,
      double vesselLength) {
    double baseTime = 0;

    if (thickness >= 10 && thickness <= 16) {
      if (diameter <= 2500) {
        baseTime = 1.5;
      } else if (diameter <= 3500) {
        baseTime = 2;
      } else {
        baseTime = 3;
      }
    } else if (thickness >= 17 && thickness <= 25) {
      if (diameter <= 1000) {
        baseTime = 2;
      } else if (diameter <= 2500) {
        baseTime = 2.5;
      } else if (diameter <= 3500) {
        baseTime = 3;
      } else {
        baseTime = 3.5;
      }
    } else if (thickness >= 26 && thickness <= 50) {
      if (diameter <= 2500) {
        baseTime = 4;
      } else if (diameter <= 3500) {
        baseTime = 4;
      } else {
        baseTime = 4.5;
      }
    } else if (thickness >= 51 && thickness <= 75) {
      if (diameter <= 2500) {
        baseTime = 4.5;
      } else if (diameter <= 3500) {
        baseTime = 5;
      } else {
        baseTime = 5.5;
      }
    } else if (thickness > 75) {
      if (diameter <= 2500) {
        baseTime = 5;
      } else if (diameter <= 3500) {
        baseTime = 5.5;
      } else {
        baseTime = 6;
      }
    }

    // Total seams including end seams
    int totalSeams = ((vesselLength / 2500).ceil() - 1) + 2;
    return baseTime * totalSeams;
  }

  /// Nozzle Welding Time (T4)
  double calculateNozzleTime(List<Map<int, int>> nozzles) {
    double totalNozzleTime = 0;

    // Iterate through the list of nozzles
    for (var entry in nozzles) {
      entry.forEach((size, quantity) {
        if (size >= 1 && size <= 12) {
          // Small nozzle (1"-12")
          totalNozzleTime += 1.5 * quantity;
        } else if (size >= 14 && size <= 24) {
          // Medium nozzle (14"-24")
          totalNozzleTime += 2 * quantity;
        } else if (size >= 26 && size <= 40) {
          // Large nozzle (26"-40")
          totalNozzleTime += 3 * quantity;
        } else {
          throw ArgumentError(
              "Invalid nozzle size: $size. Supported sizes are 1\"-40\".");
        }
      });
    }

    return totalNozzleTime;
  }

  double calculateSkirtCuttingAndRollingTime(double thickness, double diameter,
      double length) {
    return calculateCuttingAndRollingTime(thickness, diameter, length);
  }

  double calculateSkirtLongSeamWeldingTime(double thickness, double diameter,
      double length) {
    return calculateLongSeamWeldingTime(thickness, diameter, length);
  }

  double calculateSkirtCircumferentialSeamTime(double thickness,
      double diameter, double length) {
    return calculateCircumferentialSeamTime(thickness, diameter, length);
  }

  double calculateSkirtFabricationTime({
    required double skirtThickness,
    required double skirtDiameter,
    required double skirtLength,
  }) {
    double t1 = calculateSkirtCuttingAndRollingTime(
        skirtThickness, skirtDiameter, skirtLength);
    double t2 = calculateSkirtLongSeamWeldingTime(
        skirtThickness, skirtDiameter, skirtLength);
    double t3 = calculateSkirtCircumferentialSeamTime(
        skirtThickness, skirtDiameter, skirtLength);

    return t1 + t2 + t3; // Total skirt fabrication time
  }


  /// Externals/Internals Welding Time (T5)
  double calculateExternalsAndInternalsTime({
    required bool includeExternal, // Whether to include external welding time
    required bool includeInternal, // Whether to include internal welding time
  }) {
    double externalTime = includeExternal ? 2.5 : 0.0; // External welding time
    double internalTime = includeInternal ? 3.5 : 0.0; // Internal welding time

    return externalTime + internalTime; // Total time based on selection
  }

  /// Standard Times (T6 to T11)
  Map<String, double> calculateStandardTimes() {
    return {
      "Post-Weld Heat Treatment (T6)": 2.0,
      "Quality Control Checks (T7)": 7.0,
      "Hydrotesting (T8)": 2.0,
      "Painting (T9)": 7.0,
      "Internal Assembly (T10)": 3.0,
      "Packing (T11)": 2.0,
    };
  }


  /// Fabrication Breakdown for a Single Vessel
  Map<String, double> calculateFabricationBreakdown({
    required double thickness,
    required double diameter,
    required double length,
    required List<Map<int, int>> nozzles,
    required bool includeExternal,
    required bool includeInternal,
    required String supportType,
    double? skirtThickness,
    double? skirtDiameter,
    double? skirtLength,
    required String material,
  }) {
    double t1 = calculateCuttingAndRollingTime(thickness, diameter, length);
    double t2 = calculateLongSeamWeldingTime(thickness, diameter, length);
    double t3 = calculateCircumferentialSeamTime(thickness, diameter, length);
    double t4 = calculateNozzleTime(nozzles);
    double t5 = calculateExternalsAndInternalsTime(
      includeExternal: includeExternal,
      includeInternal: includeInternal,
    );

    double tSkirt = 0.0;
    if (supportType == "Skirt") {
      tSkirt = calculateSkirtFabricationTime(
        skirtThickness: skirtThickness!,
        skirtDiameter: skirtDiameter!,
        skirtLength: skirtLength!,
      );
    }

    Map<String, double> standardTimes = calculateStandardTimes();
    double materialFactor = getMaterialFactor(material);

    Map<String, double> adjustedBreakdown = {
      "Cutting & Rolling Time (T1)": t1 * materialFactor,
      "Long Seam Welding Time (T2)": t2 * materialFactor,
      "Circumferential Seam Welding Time (T3)": t3 * materialFactor,
      "Nozzle Welding Time (T4)": t4 * materialFactor,
      "Externals/Internals Welding Time (T5)": t5 * materialFactor,
      if (supportType == "Skirt") "Skirt Fabrication Time": tSkirt *
          materialFactor,
      for (var entry in standardTimes.entries)
        entry.key: entry.value * materialFactor,
    };

    return adjustedBreakdown;
  }

  /// Fabrication Times for Multiple Vessels
  List<Map<String,
      dynamic>> calculateMultipleVesselFabricationTimesWithBreakdown({
    required int numberOfVessels,
    required double thickness,
    required double diameter,
    required double length,
    required List<Map<int, int>> nozzles,
    required bool includeExternal,
    required bool includeInternal,
    required String supportType,
    double? skirtThickness,
    double? skirtDiameter,
    double? skirtLength,
    required String material,
  }) {
    Map<String, double> breakdown = calculateFabricationBreakdown(
      thickness: thickness,
      diameter: diameter,
      length: length,
      nozzles: nozzles,
      includeExternal: includeExternal,
      includeInternal: includeInternal,
      supportType: supportType,
      skirtThickness: skirtThickness,
      skirtDiameter: skirtDiameter,
      skirtLength: skirtLength,
      material: material,
    );

    double baseTime = breakdown.values.reduce((a, b) => a + b);

    List<Map<String, dynamic>> vesselDetails = [];
    for (int i = 1; i <= numberOfVessels; i++) {
      vesselDetails.add({
        "Vessel": "Vessel $i",
        "Activities": breakdown,
        "Total Time (days)": (baseTime + (i - 1) * 2).ceil(),
      });
    }

    return vesselDetails;
  }
}