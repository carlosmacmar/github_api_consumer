import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/features/github/presentation/bloc/issues/issues_cubit.dart';

class SortDropdownWidget extends StatefulWidget {
  const SortDropdownWidget({Key? key}) : super(key: key);

  @override
  State<SortDropdownWidget> createState() => _SortDropdownWidgetState();
}

class _SortDropdownWidgetState extends State<SortDropdownWidget> {
  SortOption dropdownValue = SortOption.created;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SortOption>(
      value: dropdownValue,
      dropdownColor: Colors.black54,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      underline: Container(
        height: 1,
        color: Colors.white,
      ),
      onChanged: (SortOption? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
        BlocProvider.of<IssuesCubit>(context).updateSortOption(newValue!);
      },
      items: SortOption.values.map((SortOption value) {
        return DropdownMenuItem<SortOption>(
          value: value,
          child: Text(value.toShortString()),
        );
      }).toList(),
    );
  }
}
