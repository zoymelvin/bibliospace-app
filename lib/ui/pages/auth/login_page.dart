import 'package:bibliospace/blocs/auth/auth_bloc.dart';
import 'package:bibliospace/ui/pages/home/main_page.dart';
import 'package:bibliospace/ui/pages/auth/register_page.dart';
import 'package:bibliospace/ui/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  bool _showSuccessTransition = false;
  double _opacity = 0.0; 
  double _buttonWidth = 50.0; 
  String _currentLottie = 'assets/animations/login_animation.json';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1200)
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), 
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animController, 
      curve: Curves.easeOutBack
    ));

    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
        _buttonWidth = MediaQuery.of(context).size.width - 48; 
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            setState(() {
              _showSuccessTransition = true;
            });

            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              }
            });
          } else if (state is AuthFailure) {
            // [POIN 3f] Tampilan Gagal
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Lottie.asset(
                              _currentLottie,
                              key: ValueKey(_currentLottie),
                              height: 280,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              children: [
                                Text(
                                  "Welcome Back!",
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),

                          AnimatedOpacity(
                            opacity: _opacity,
                            duration: const Duration(seconds: 1),
                            child: Column(
                              children: [
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    if(hasFocus) {
                                      setState(() => _currentLottie = 'assets/animations/login_animation.json');
                                    }
                                  },
                                  child: CustomTextField(
                                    controller: _emailController,
                                    label: "Email",
                                    hintText: "example@email.com",
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      _currentLottie = hasFocus 
                                          ? 'assets/animations/login_animation.json' 
                                          : 'assets/animations/login_animation.json';
                                    });
                                  },
                                  child: CustomTextField(
                                    controller: _passwordController,
                                    label: "Password",
                                    hintText: "******",
                                    isPassword: true,
                                  ),
                                ),
                                
                                const SizedBox(height: 30),
                                AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.elasticOut,
                                  width: _buttonWidth,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                          AuthLoginRequested(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: state is AuthLoading
                                        ? const SizedBox(
                                            height: 20, 
                                            width: 20, 
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                          )
                                        : const Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const RegisterPage()),
                                    );
                                  },
                                  child: const Text("Don't have an account? Register"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (_showSuccessTransition)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/loading_animation.json', 
                          width: 250, 
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        const Text("Login Berhasil...", style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}