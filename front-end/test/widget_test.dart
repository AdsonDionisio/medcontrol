import 'package:flutter_test/flutter_test.dart';

import 'package:medcontrol_frontend/app/app_widget.dart';

void main() {
  testWidgets('exibe a home com acessos rapidos do MedControl', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MedControlApp());

    expect(find.text('Acessos rapidos'), findsOneWidget);
    expect(find.text('Cadastrar paciente'), findsOneWidget);
    expect(find.text('Medicamentos'), findsWidgets);
    expect(find.text('Agendamentos'), findsWidgets);
    expect(find.text('Historico'), findsWidgets);
    expect(find.text('Afericoes'), findsWidgets);
    expect(find.text('Backup'), findsOneWidget);
  });

  testWidgets('atalho de medicamentos navega para a area correta', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MedControlApp());

    await tester.tap(find.text('Medicamentos').first);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Area reservada para cadastrar, listar e acompanhar os medicamentos.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('atalho de backup navega para a tela correta', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MedControlApp());

    await tester.scrollUntilVisible(find.text('Backup'), 300);
    await tester.tap(find.text('Backup'));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar backup'), findsOneWidget);
    expect(
      find.text(
        'Esta tela fica preparada para evoluir com backup local, exportacao e restauracao.',
      ),
      findsOneWidget,
    );
  });
}
