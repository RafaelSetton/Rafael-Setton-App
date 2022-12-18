# Rafael Setton - MyFlutterProject

## Instruções de uso

```bash
~$ git clone https://github.com/RafaelSetton/My-Flutter-Project.git
~$ cd My-Flutter-Project
~/My-Flutter-Project$ flutter pub get
~/My-Flutter-Project$ flutter build apk
```

Baixe e Instale `~/My-Flutter-Project/build/app/outputs/flutter-apk/app-release.apk` no seu dispositivo android.

---

## Informações

Descrição dos Commits:<br/>

1. Initial Commit
   - Criação do projeto com as páginas:
     - Cadastro
     - Log-in
     - Página de Usuário
     - Calculadora
     - Cálculo de IMC
     - Color Game
     - Conversor de Moedas
     - TO DOs list
1. Firebase
   - Permissão de acesso à internet
   - Layout Conversor de Moedas
   - Recarregar na página de Login
   - Alteração na forma de armazenamento
   - Removed `main()` from files
1. Problemas Com Build
   - Mudanças nas configurações
1. Refactor Encryption
   - Refatoração a [criptografia](lib\services\cryptography.dart)
1. Prevent Unwanted Popping
   - Implementação de `WillPopScope`
1. Changes in Database
   - Reimplementação do [Banco de Dados](lib\services\storage.dart)
1. Add Workout Timer
   - Adição da página [WorkoutTimer](lib\pages\workoutTimer)
   - Adição do Ícone
1. Migrate
   - Consertar alguns bugs
   - Atualizações de funções descontinuadas
1. Remodel
   - Reestruturação do projeto
1. Refactor & null-safety
   - [Splash](lib\pages\splash) adicionada
   - Migração das [Rotas](lib\routes.dart) para novo arquivo
   - Migração para Null-Safety
   - Função emptyValidator
   - Função loadVars
   - Criou [UserModel](lib\shared\models\userModel.dart)
   - SharedPreferences para [DB Local](lib\services\RAM.dart)
   - Refatorou [UserDB e WorkoutDB](lib\services\storage.dart)
1. Launcher Icon
   - Ícone personalizado
1. Update Calculadora
   - Petit Parser para calcular
1. Fix Calculadora
   - Migrar para Function Tree
   - Separar funções compartilhadas
1. Update Workout Timer
   - Criação de Models:
     - [WorkoutModel](lib\shared\models\workoutModel.dart)
     - WorkoutSetModel
     - [UserDataModel](lib\shared\models\userDataModel.dart)
     - [ToDoModel](lib\shared\models\toDoModel.dart)
   - SelectionDialog para iniciar Workout
   - Atualização README
1. Update Workout Timer & Create ChatApp
   - Criação [ChatApp](lib\pages\chatApp)
     - Flutter Type Ahead
     - Image Picker
     - [MessageModel](lib\shared\models\messageModel.dart)
     - [ChatModel](lib\shared\models\chatModel.dart)
     - [ChatAppDB](lib\services\storage.dart)
   - Criação de Widgets compartilhados
     - [ProgressDialog](lib\shared\widgets\progressDialog.dart)
     - [LoadingScreen](lib\shared\widgets\loadingScreen.dart)
     - [ErrorScreen](lib\shared\widgets\errorScreen.dart)
   - ArgumentsModel
   - Função getArguments
   - Mover função calcular para página Calculadora
   - Função [BuildFuture](lib\shared\functions\buildFuture.dart)
1. High Score Color Game
   - Consertou erro no High Score
1. Bug-Fix e Refatorar
   - Plugins
     - Curved Navigation Bar
     - Flutter Switch
   - Implementação do tema
     - [Theme Notifier](lib\services\themenotifier.dart)
     - Claro e Escuro
     - MaterialAppWithTheme
   - Widget Input
1. Fix Bugs & DB Update
   - Deletou WorkoutSetModel
   - Remodelagem do WorkoutsDB para uma nova coleção
   - Alteração da cor da StatusBar para melhor visibilidade
   - Melhor adequação ao tema (Ainda precisa finalizar)
1. Somando Saber App
   - [Assets](lib\assets\Somando_Saber) do Somando Saber App
   - [Variáveis Globais](lib\shared\globals.dart)
   - Incorporação [Somando Saber App](lib\pages\somandoSaber)
1. Update README.md
   - Listar e descrever commits
1. Small Refactor
   - Converter `Widget Function()` para `Stateless Widget`
   - Criou [enum para erro ao registrar](lib\shared\enums\registerErrors.dart)
   - Reformulou abas da [Home](lib\pages\home)
1. DB & Buttons Refactoring
   - Reformatação dos NavButton
   - Reorganização dos Bancos de Dados
     - ScoresDB

## Páginas:<br/>

- [Splash](./lib/pages/splash)<br/>
- [Cadastro](./lib/pages/register)<br/>
- [Log-in](./lib/pages/login)<br/>
- [Página de Usuário](./lib/pages/home)<br/>
- [Calculadora](./lib/pages/calculadora)<br/>
- [Cálculo de IMC](./lib/pages/IMC)<br/>
- [Color Game](./lib/pages/colorGame)<br/>
- [Conversor de Moedas](./lib/pages/conversor)<br/>
- [TO DOs list](./lib/pages/toDo)<br/>
- [Workout Timer](./lib/pages/workoutTimer)<br/>
- [Chat App](./lib/pages/chatApp)<br/>
- [Somando Saber App](./lib/pages/somandoSaber)<br/>
