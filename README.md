# MedControl

Aplicativo mobile em Flutter para controle de medicamentos, pensado para uso simples, legível e offline. O projeto foi estruturado para apoiar pacientes, especialmente idosos, com cadastro local, agenda de medicação, histórico de doses, aferições de saúde, notificações e preparação para backup.

## Estado atual do projeto

O repositório está dividido em duas partes:

- `front-end/`: aplicação Flutter em desenvolvimento ativo
- `back-end/`: pasta reservada para a API FastAPI, ainda não implementada

Hoje, a aplicação funcional está no `front-end`.

## Funcionalidades já implementadas

- Navegação principal com acesso para início, medicamentos, agendamentos, histórico, aferições, configurações e backup
- Tema visual com foco em acessibilidade, legibilidade e áreas de toque maiores
- Persistência local offline com `Isar`
- Cadastro básico de paciente com nome, idade e geração automática de `idInterno`
- Estrutura base de domínio para:
  - paciente
  - medicamento
  - agendamento de medicação
  - registro de dose
  - aferição de saúde
  - configuração de backup
- Tela inicial com atalhos rápidos
- Módulo de medicamentos com listagem e navegação para cadastro/detalhe
- Agenda do dia com confirmação e adiamento de doses
- Histórico de registros
- Base para medições de saúde
- Serviço de notificações locais com suporte a alarmes e ações no Android

## Stack utilizada

- Flutter
- Dart
- Isar Community
- flutter_local_notifications
- shared_preferences
- timezone
- fl_chart

## Estrutura do projeto

```text
medcontrol/
├── front-end/
│   ├── lib/
│   │   ├── app/
│   │   ├── core/
│   │   │   ├── database/
│   │   │   ├── services/
│   │   │   └── theme/
│   │   └── features/
│   │       ├── backup/
│   │       ├── history/
│   │       ├── home/
│   │       ├── measurements/
│   │       ├── medications/
│   │       ├── navigation/
│   │       ├── patient/
│   │       ├── schedules/
│   │       └── settings/
│   ├── test/
│   └── pubspec.yaml
└── back-end/
```

## Pontos importantes da aplicação atual

- O bootstrap do app está em `front-end/lib/main.dart`
- O banco local é inicializado em `front-end/lib/core/database/app_database.dart`
- As rotas centrais ficam em `front-end/lib/app/app_routes.dart`
- O cadastro do paciente fica em `front-end/lib/features/patient/`
- O módulo de medicamentos fica em `front-end/lib/features/medications/`
- O módulo de agenda fica em `front-end/lib/features/schedules/`
- O serviço de notificações fica em `front-end/lib/core/services/notification_service.dart`

## Requisitos

- Flutter instalado e configurado
- Dart SDK compatível com o projeto
- Android Studio ou SDK Android configurado, caso queira rodar no Android
- Dispositivo Android autorizado no `adb`, caso queira rodar em aparelho físico

No Windows, se o Flutter reclamar de suporte a symlink ao instalar dependências com plugins, ative o `Developer Mode` do sistema.

## Como rodar o front-end

A partir da raiz do projeto:

```powershell
cd front-end
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Para rodar em um dispositivo específico:

```powershell
cd front-end
flutter devices
flutter run -d <device_id>
```

Exemplo de device Android físico:

```powershell
flutter run -d RXCXA0A1LQY
```

## Como validar o projeto

```powershell
cd front-end
flutter analyze
flutter test
flutter build apk --debug
```

## Persistência local

A aplicação utiliza `Isar` para salvar os dados localmente no dispositivo. Isso permite:

- funcionamento offline
- persistência do cadastro do paciente
- base pronta para persistir medicamentos, agenda, histórico e aferições

Os modelos do banco ficam em `front-end/lib/core/database/models/`.

## Notificações

O projeto já possui uma base de notificações locais para Android, incluindo:

- criação de canal de alarme
- permissão para notificações
- permissão para alarmes exatos
- ações de confirmar e adiar

Essas rotinas ficam em `front-end/lib/core/services/notification_service.dart`.

## Testes existentes

O projeto já possui validações automatizadas para:

- navegação principal
- atalhos da home
- inicialização da persistência
- salvamento e reabertura do cadastro do paciente

## Back-end

A pasta `back-end/` está reservada para a API em FastAPI, mas ainda não há implementação funcional publicada no repositório neste momento.

## Próximos passos sugeridos

- implementar o back-end com FastAPI
- sincronizar dados entre Flutter e API
- finalizar CRUD completo de medicamentos
- finalizar CRUD completo de agendamentos
- consolidar histórico e aferições com dashboards
- implementar fluxo real de backup e restauração

## Objetivo do MVP

O objetivo do MedControl é oferecer uma base simples e confiável para controle de medicamentos, com foco em uso offline, acessibilidade e evolução incremental do sistema.
