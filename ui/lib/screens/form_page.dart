import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxonomy_method/model/criteria.dart';
import 'package:taxonomy_method/model/criteria_type.dart';
import 'package:taxonomy_method/screens/matrix_page.dart';

class CriteriaForm extends StatefulWidget {
  static const routeName = '/form';
  @override
  _CriteriaFormState createState() => _CriteriaFormState();
}

class _CriteriaFormState extends State<CriteriaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _idealPointController;
  late TextEditingController _antiIdealPointController;
  static List<Criteria> criteriaList = [Criteria.empty()];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _weightController = TextEditingController();
    _idealPointController = TextEditingController();
    _antiIdealPointController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _idealPointController.dispose();
    _antiIdealPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Criteria Input'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // name textfield
              SizedBox(
                height: 20,
              ),
              Text(
                'Add Criteria',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              _getCriteria(),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  FormState? _currentState = _formKey.currentState;
                  if (_currentState != null && _currentState.validate()) {
                    _currentState.save();
                    print(_CriteriaFormState.criteriaList.length);
                    print(
                        _CriteriaFormState.criteriaList.map((e) => e.toJson()));
                    Navigator.pushNamed(context, MatrixPage.routeName,
                        arguments: _CriteriaFormState.criteriaList);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCriteria() {
    List<Widget> criteriaTextFields = [];
    for (int i = 0; i < criteriaList.length; i++) {
      criteriaTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: CriteriaTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last criteria row
            _addRemoveButton(i == criteriaList.length - 1, i),
          ],
        ),
      ));
    }
    return Expanded(flex: 2, child: ListView(children: criteriaTextFields));
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all criteria textfields
          criteriaList.insert(0, Criteria.empty());
        } else
          criteriaList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CriteriaTextFields extends StatefulWidget {
  final int index;
  CriteriaTextFields(this.index);
  @override
  _CriteriaTextFieldsState createState() => _CriteriaTextFieldsState();
}

class _CriteriaTextFieldsState extends State<CriteriaTextFields> {
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _idealPointController;
  late TextEditingController _antiIdealPointController;
  List<String> _criteriaTypeList = [
    CriteriaType.benefit.name,
    CriteriaType.cost.name
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _weightController = TextEditingController();
    _idealPointController = TextEditingController();
    _antiIdealPointController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _idealPointController.dispose();
    _antiIdealPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = _CriteriaFormState.criteriaList[widget.index].name;
      _weightController.text =
          _CriteriaFormState.criteriaList[widget.index].weight.toString();
      _idealPointController.text =
          _CriteriaFormState.criteriaList[widget.index].idealPoint.toString();
      _antiIdealPointController.text = _CriteriaFormState
          .criteriaList[widget.index].antiIdealPoint
          .toString();
    });

    return Column(
      children: [
        ListTile(
          leading: Text("Name:"),
          title: TextFormField(
            style: TextStyle(fontWeight: FontWeight.bold),
            showCursor: false,
            controller: _nameController,
            onChanged: (v) {
              _CriteriaFormState.criteriaList[widget.index].name = v;
            },
            decoration: InputDecoration(hintText: 'Enter the criteria name'),
            validator: (v) {
              Set<String> criteriaNames =
                  _CriteriaFormState.criteriaList.map((e) => e.name).toSet();

              if (v != null) {
                if (v.trim().isEmpty) return 'Please enter something';
                bool valueInSet = criteriaNames.add(v);
                if (valueInSet) return 'Criteria names must be unique';
              } else {
                return null;
              }
            },
          ),
        ),
        ListTile(
          leading: Text("Weight:"),
          title: TextFormField(
            showCursor: false,
            controller: _weightController,
            onChanged: (v) => _CriteriaFormState
                .criteriaList[widget.index].weight = double.parse(v),
            decoration: InputDecoration(hintText: 'Enter it\'s weight'),
            validator: (v) {
              if (v != null &&
                  (double.parse(v) < 0.0 || double.parse(v) > 100.0))
                return 'Valid range between 0.0 - 100.0';
              return null;
            },
          ),
        ),
        ListTile(
          leading: Text("Ideal Point:"),
          title: TextFormField(
            showCursor: false,
            controller: _idealPointController,
            onChanged: (v) => _CriteriaFormState
                .criteriaList[widget.index].idealPoint = double.parse(v),
            decoration: InputDecoration(hintText: 'Enter it\'s Ideal Point'),
            validator: (v) {
              if (v != null &&
                  (double.parse(v) < 0.0 || double.parse(v) > 100.0))
                return 'Valid range between 0.0 - 100.0';
              return null;
            },
          ),
        ),
        ListTile(
          leading: Text("Anti Ideal Point:"),
          title: TextFormField(
            showCursor: false,
            controller: _antiIdealPointController,
            onChanged: (v) => _CriteriaFormState
                .criteriaList[widget.index].antiIdealPoint = double.parse(v),
            decoration:
                InputDecoration(hintText: 'Enter it\'s Anti Ideal Point'),
            validator: (v) {
              if (v != null) {
                Criteria _currentCriteria =
                    _CriteriaFormState.criteriaList[widget.index];
                if (double.parse(v) < 0.0 || double.parse(v) > 100.0)
                  return 'Valid range between 0.0 - 100.0';
                else {
                  return null;
                }
              } else {
                return null;
              }
            },
          ),
        ),
        ListTile(
          leading: Text("Criteria Type:"),
          title: DropdownButtonFormField(
            value: getCriteriaTypeName(
                _CriteriaFormState.criteriaList[widget.index].type),
            items: _criteriaTypeList.map((String e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e),
              );
            }).toList(),
            isExpanded: true,
            onChanged: (String? v) {
              _CriteriaFormState.criteriaList[widget.index].type =
                  getCriteriaType(v);
            },
            decoration: InputDecoration(hintText: 'Select Criteria Type'),
            validator: (String? value) {
              if (value == null) {
                return "can't empty";
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }
}
