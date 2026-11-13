import 'package:material_ui/material_ui.dart';

class Loader extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive();
  }
}
