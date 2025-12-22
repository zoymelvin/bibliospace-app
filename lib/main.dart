import 'package:bibliospace/blocs/book/book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'data/repositories/auth_repository.dart';
import 'blocs/auth/auth_bloc.dart';
import 'ui/pages/auth/login_page.dart';
import 'data/repositories/book_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(), 
        ),
        RepositoryProvider(
          create: (context) => BookRepository(), 
        ),
      ],  
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BookBloc(
              bookRepository: context.read<BookRepository>(),
              )..add(FetchBooks()),
          )
        ],
        child: MaterialApp(
          title: 'BiblioSpace',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
          home: const LoginPage(),
        ),
      ),
    );
  }
}