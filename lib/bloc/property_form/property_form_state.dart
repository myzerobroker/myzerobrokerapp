import 'package:equatable/equatable.dart';
import 'package:my_zero_broker/data/models/property_form_model.dart';


class PropertyFormState extends Equatable {
  final PropertyFormModel form;

  const PropertyFormState({required this.form});

  PropertyFormState copyWith({PropertyFormModel? form}) {
    return PropertyFormState(
      form: form ?? this.form,
    );
  }

  @override
  List<Object?> get props => [form];
}
