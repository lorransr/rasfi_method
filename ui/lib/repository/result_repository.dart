import 'package:taxonomy_method/model/rasfi_input.dart';
import 'package:taxonomy_method/model/model_results.dart';
import 'package:taxonomy_method/provider/api_provider.dart';

class ResultsRepository {
  ApiProvider _apiProvider = ApiProvider();

  Future<ModelResults> getRanking(RasfiInput input) {
    return _apiProvider.getRanking(input);
  }
}
