import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxonomy_method/model/criteria.dart';
import 'package:taxonomy_method/model/criteria_type.dart';
import 'package:taxonomy_method/screens/matrix_page.dart';

class FormPage extends StatefulWidget {
  static const routeName = '/form';
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Map<String, String> _formdata = {};
  final _textController = TextEditingController();
  List<Criteria> _criteriaList = [];
  var _criteriaTypeList = <String>[
    CriteriaType.benefit.toString().split(".").last,
    CriteriaType.cost.toString().split(".").last
  ];
  var _dropDownValue;
  var _criteriaWeight;
  late int _lastRemovedPos;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  List<GlobalKey> _formKeyList = [];
  bool _ageHasError = false;
  bool _genderHasError = false;

  var genderOptions = ['Male', 'Female', 'Other'];

  void _onChanged(dynamic val) => debugPrint(val.toString());

  void _snackValidationError(String message) {
    final snack = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[200],
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _addCriteria() {
    setState(() {
      Criteria newCriteria = Criteria(
          name: _textController.text,
          type: CriteriaType.benefit,
          weight: 1.0,
          antiIdealPoint: 0.0,
          idealPoint:
              0.0); //Criteria(_textController.text, CriteriaType.benefit);
      if (["", " ", "  "].contains(newCriteria.name) ||
          newCriteria.name.isEmpty) {
        _snackValidationError("Criteria name must not be empty");
      } else if (newCriteria.name.length < 3) {
        _snackValidationError("Criteria name must have at least 3 characters");
      } else if (_criteriaList.length > 0) {
        var nameSet = _criteriaList.map((e) => e.name).toSet();
        bool valueNotInSet = nameSet.add(newCriteria.name);
        if (valueNotInSet) {
          _criteriaList.add(newCriteria);
          _textController.text = '';
        } else {
          _snackValidationError("Criteria with same name already added");
        }
      } else {
        _criteriaList.add(newCriteria);
        _textController.text = '';
      }
    });
  }

  void _submit() {
    int nErrors = _validateCriteriaList(_criteriaList);
    if (nErrors == 0) {
      print("Valid Criterias");
      Navigator.pushNamed(context, MatrixPage.routeName,
          arguments: {"criteriaList": _criteriaList});
    } else {
      print("Validation Errors were found: $nErrors");
    }
  }

  int _validateCriteriaList(List<Criteria> _criteriaList) {
    var fail = 0;
    if (_criteriaList.length < 2) {
      _snackValidationError("Please Insert at least 2 Criterias");
      fail = ++fail;
    }
    return fail;
  }

  void _dismissCriteria(
      DismissDirection direction, BuildContext context, int index) {
    setState(() {
      Criteria _lastRemoved = _criteriaList[index];
      _lastRemovedPos = index;
      _criteriaList.removeAt(index);
      final snack = SnackBar(
        content: Text('Criteria \"${_lastRemoved.name}\" removed!'),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _criteriaList.insert(_lastRemovedPos, _lastRemoved);
            });
          },
        ),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criteria Input'),
          backgroundColor: Colors.orange,
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      onSubmitted: (value) => _addCriteria(),
                      controller: _textController,
                      decoration: InputDecoration(
                          labelText: 'Add a New Criteria',
                          labelStyle: TextStyle(color: Colors.grey)),
                    )),
                    ElevatedButton(
                      child: Text('Add'),
                      onPressed: _addCriteria,
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: _criteriaList.length,
                    itemBuilder: itemBuilder)),
            Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget itemBuilder(BuildContext context, int index) {
    int keyValue = index;
    final controller = TextEditingController(text: "0.0");
    //Widget responsável por permitir dismiss
    return StatefulBuilder(
      builder:
          (BuildContext context, void Function(void Function()) setState) =>
              Dismissible(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        //A propriedade "background" representa o fundo da nossa tile, o fundo em si não possui ações
        //As ações estão no evento onDismissed
        background: Container(
          color: Colors.redAccent,
          child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        direction: DismissDirection.startToEnd,
        child: Card(
          child: Column(
            key: Key("$keyValue"),
            children: <Widget>[
              ListTile(
                title: Text(
                  _criteriaList[index].name,
                ),
              ),
              ListTile(
                leading: Text('Type: '),
                title: DropdownButton(
                  value: getCriteriaTypeName(_criteriaList[index].type),
                  onChanged: (val) {
                    _criteriaList[index].type = getCriteriaType(val as String);
                    print(val);
                    setState(() => _dropDownValue = val);
                  },
                  items: _criteriaTypeList.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
              Form(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Text('Weight: '),
                      title: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^\d*\.?\d*"))
                        ],
                        onFieldSubmitted: (val) {
                          print(val);
                        },
                        validator: (String? val) {
                          if (val == null ||
                              double.tryParse(val) == null ||
                              double.parse(val) <= 0.0 ||
                              double.parse(val) >= 100.0) {
                            return "Insert criteria weight (0.0-100.0)";
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          Form.of(primaryFocus!.context!)!.save();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          _dismissCriteria(direction, context, index);
        },
      ),
    );
  }

  // Widget alternative_form_build(BuildContext context, int index) {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: <Widget>[
  //         FormBuilder(
  //           key: _formKey,
  //           // enabled: false,
  //           onChanged: () {
  //             _formKey.currentState!.save();
  //             debugPrint(_formKey.currentState!.value.toString());
  //           },
  //           autovalidateMode: AutovalidateMode.disabled,
  //           initialValue: const {
  //             'movie_rating': 5,
  //             'best_language': 'Dart',
  //             'age': '13',
  //             'gender': 'Male'
  //           },
  //           skipDisabled: true,
  //           child: Column(
  //             children: <Widget>[
  //               const SizedBox(height: 15),
  //               FormBuilderTextField(
  //                 autovalidateMode: AutovalidateMode.always,
  //                 name: 'age',
  //                 decoration: InputDecoration(
  //                   labelText: 'Age',
  //                   suffixIcon: _ageHasError
  //                       ? const Icon(Icons.error, color: Colors.red)
  //                       : const Icon(Icons.check, color: Colors.green),
  //                 ),
  //                 onChanged: (val) {
  //                   setState(() {
  //                     _ageHasError =
  //                         !(_formKey.currentState?.fields['age']?.validate() ??
  //                             false);
  //                   });
  //                 },
  //                 // valueTransformer: (text) => num.tryParse(text),
  //                 validator: FormBuilderValidators.compose([
  //                   FormBuilderValidators.required(),
  //                   FormBuilderValidators.numeric(),
  //                   FormBuilderValidators.max(70),
  //                 ]),
  //                 // initialValue: '12',
  //                 keyboardType: TextInputType.number,
  //                 textInputAction: TextInputAction.next,
  //               ),
  //               FormBuilderDropdown<String>(
  //                 // autovalidate: true,
  //                 name: 'gender',
  //                 decoration: InputDecoration(
  //                   labelText: 'Gender',
  //                   suffix: _genderHasError
  //                       ? const Icon(Icons.error)
  //                       : const Icon(Icons.check),
  //                 ),
  //                 // initialValue: 'Male',
  //                 allowClear: true,
  //                 hint: const Text('Select Gender'),
  //                 validator: FormBuilderValidators.compose(
  //                     [FormBuilderValidators.required()]),
  //                 items: genderOptions
  //                     .map((gender) => DropdownMenuItem(
  //                           alignment: AlignmentDirectional.center,
  //                           value: gender,
  //                           child: Text(gender),
  //                         ))
  //                     .toList(),
  //                 onChanged: (val) {
  //                   setState(() {
  //                     _genderHasError = !(_formKey
  //                             .currentState?.fields['gender']
  //                             ?.validate() ??
  //                         false);
  //                   });
  //                 },
  //                 valueTransformer: (val) => val?.toString(),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Row(
  //           children: <Widget>[
  //             Expanded(
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   if (_formKey.currentState?.saveAndValidate() ?? false) {
  //                     debugPrint(_formKey.currentState?.value.toString());
  //                   } else {
  //                     debugPrint(_formKey.currentState?.value.toString());
  //                     debugPrint('validation failed');
  //                   }
  //                 },
  //                 child: const Text(
  //                   'Submit',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 20),
  //             Expanded(
  //               child: OutlinedButton(
  //                 onPressed: () {
  //                   _formKey.currentState?.reset();
  //                 },
  //                 // color: Theme.of(context).colorScheme.secondary,
  //                 child: Text(
  //                   'Reset',
  //                   style: TextStyle(
  //                       color: Theme.of(context).colorScheme.secondary),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
