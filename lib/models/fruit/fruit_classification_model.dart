class FruitClassification {
  final bool success;
  final String mode;
  final Prediction prediction;
  final List<TopPrediction> top5Predictions;
  final Performance performance;
  final Metadata metadata;

  FruitClassification({
    required this.success,
    required this.mode,
    required this.prediction,
    required this.top5Predictions,
    required this.performance,
    required this.metadata,
  });

  factory FruitClassification.fromJson(Map<String, dynamic> json) {
    return FruitClassification(
      success: json['success'] ?? false,
      mode: json['mode'] ?? '',
      prediction: Prediction.fromJson(json['prediction'] ?? {}),
      top5Predictions:
          (json['top_5_predictions'] as List?)
              ?.map((e) => TopPrediction.fromJson(e))
              .toList() ??
          [],
      performance: Performance.fromJson(json['performance'] ?? {}),
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'mode': mode,
      'prediction': prediction.toJson(),
      'top_5_predictions': top5Predictions.map((e) => e.toJson()).toList(),
      'performance': performance.toJson(),
      'metadata': metadata.toJson(),
    };
  }
}

class Prediction {
  final String className;
  final double confidence;
  final String confidencePercentage;

  Prediction({
    required this.className,
    required this.confidence,
    required this.confidencePercentage,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      className: json['class'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      confidencePercentage: json['confidence_percentage'] ?? '0%',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class': className,
      'confidence': confidence,
      'confidence_percentage': confidencePercentage,
    };
  }
}

class TopPrediction {
  final int rank;
  final String className;
  final double confidence;
  final String confidencePercentage;

  TopPrediction({
    required this.rank,
    required this.className,
    required this.confidence,
    required this.confidencePercentage,
  });

  factory TopPrediction.fromJson(Map<String, dynamic> json) {
    return TopPrediction(
      rank: json['rank'] ?? 0,
      className: json['class'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      confidencePercentage: json['confidence_percentage'] ?? '0%',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'class': className,
      'confidence': confidence,
      'confidence_percentage': confidencePercentage,
    };
  }
}

class Performance {
  final String featureExtractionTime;
  final String predictionTime;
  final String totalTime;
  final int featuresDimension;

  Performance({
    required this.featureExtractionTime,
    required this.predictionTime,
    required this.totalTime,
    required this.featuresDimension,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      featureExtractionTime: json['feature_extraction_time'] ?? '0s',
      predictionTime: json['prediction_time'] ?? '0s',
      totalTime: json['total_time'] ?? '0s',
      featuresDimension: json['features_dimension'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feature_extraction_time': featureExtractionTime,
      'prediction_time': predictionTime,
      'total_time': totalTime,
      'features_dimension': featuresDimension,
    };
  }
}

class Metadata {
  final String modelType;
  final int totalClasses;

  Metadata({required this.modelType, required this.totalClasses});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      modelType: json['model_type'] ?? '',
      totalClasses: json['total_classes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'model_type': modelType, 'total_classes': totalClasses};
  }
}
