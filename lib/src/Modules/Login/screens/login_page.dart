// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_local_variable, avoid_print, deprecated_member_use
import 'package:des/src/Commom/rest_client.dart';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalConstants/textfield.dart';
import 'package:des/src/Modules/PageviewController/pageviewController/home_page_view.dart';
import 'package:des/src/Modules/Login/services/login_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPass = true;
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoSlide;
  late Animation<double> _formOpacity;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );
    _logoSlide =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );

    _formOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );
    _formSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    final restClient = RestClient();
    final authService = AuthService(restClient);

    bool success = await authService.userLogin(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      await _controller.reverse();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              pageviewController(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
            var offsetAnimation = animation.drive(tween);
            var fadeAnimation = animation.drive(fadeTween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.background),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 160),
                        SlideTransition(
                          position: _logoSlide,
                          child: FadeTransition(
                            opacity: _logoOpacity,
                            child: Image.asset(
                              Assets.homelogo,
                              width: 400,
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                        FadeTransition(
                          opacity: _formOpacity,
                          child: SlideTransition(
                            position: _formSlide,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Faça seu',
                                    style: principalFont.bold(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' login',
                                        style: principalFont.bold(
                                          color: const Color(0XFFb0c32e),
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: 340,
                            child: Column(
                              children: [
                                FadeTransition(
                                  opacity: _formOpacity,
                                  child: SlideTransition(
                                    position: _formSlide,
                                    child: TextFormField(
                                      cursorColor: const Color(0XFFb0c32e),
                                      controller: _emailController,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OUTFIT',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email Inválido';
                                        }
                                        if (value.length < 5) {
                                          return 'Email muito curto';
                                        }
                                        if (!value.contains('@')) {
                                          return 'Email Inválido';
                                        }
                                        if (!value.contains('.com')) {
                                          return 'Email Inválido';
                                        }
                                        return null;
                                      },
                                      decoration:
                                          emailAuthDecoration('USUÁRIO'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                FadeTransition(
                                  opacity: _formOpacity,
                                  child: SlideTransition(
                                    position: _formSlide,
                                    child: TextFormField(
                                      cursorColor: const Color(0XFFb0c32e),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OUTFIT',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      controller: _passwordController,
                                      obscureText: showPass,
                                      validator: (String? pass) {
                                        if (pass == null || pass.isEmpty) {
                                          return 'Senha Inválida';
                                        }
                                        if (pass.length < 5) {
                                          return 'Senha muito curta';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'SENHA',
                                        fillColor:
                                            Color(0xFF282E36).withOpacity(0.5),
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: Color(0XFFb0c32e),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            showPass
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: const Color(0XFFb0c32e),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showPass = !showPass;
                                            });
                                          },
                                        ),
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF666F7B),
                                          fontFamily: 'OUTFIT',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0XFFb0c32e),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0XFFb0c32e),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 60),
                                FadeTransition(
                                  opacity: _formOpacity,
                                  child: SlideTransition(
                                    position: _formSlide,
                                    child: SizedBox(
                                      width: 350,
                                      height: 50,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Color(0xFF464C54)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: _handleLogin,
                                        child: isLoading
                                            ? CircularProgressIndicator(
                                                color: const Color.fromARGB(
                                                    255, 58, 58, 58),
                                              )
                                            : Text(
                                                'ENTRAR',
                                                style: principalFont.medium(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 20,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 350),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
