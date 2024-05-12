import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gestor_vendas/common/providers/providers.dart';
import 'package:gestor_vendas/dashboard/presentation/dashboard_page.dart';
import 'package:gestor_vendas/novo_pedido/presentation/cubit/novo_pedido_cubit.dart';
import 'package:gestor_vendas/novo_pedido/presentation/cubit/novo_pedido_state.dart';
import 'package:gestor_vendas/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    minimumSize: Size.fromWidth(800),
    title: "Gestor de Vendas",
    windowButtonVisibility: false,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    Phoenix(
      child: bloc.MultiBlocProvider(
        providers: providers,
        //     [
        //       providers,
        //       // bloc.BlocProvider<LoginCubit>(create: (context) => LoginCubit()..inicio()),
        //       // bloc.BlocProvider<UsuarioCubit>(create: (context) => UsuarioCubit()),
        // //       bloc.BlocProvider<CategoriaCubit>(create: (context) => CategoriaCubit(context)),
        // //       ChangeNotifierProvider.value(
        // //   value: CategoriaEntity(id: 0),
        // // ),
        //     ],
        child: App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: AppTheme.ligth(context).buildThemeData(),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: BotToastInit(),
            title: 'Flutter Demo',
            theme: theme,
            supportedLocales: const [Locale('pt', 'BR')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: BlocBuilder<NovoPedidoCubit, NovoPedidoState>(
              builder: (BuildContext context, NovoPedidoState state) {
                return RelatorioScreen();
              },
            ),
          );
        });
  }
}
