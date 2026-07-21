import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _translations = {
    'en': {
      'app_name': 'READ', 'login': 'Log In', 'register': 'Sign Up', 'guest': 'Enter as Guest',
      'home': 'Home', 'reels': 'Reels', 'sales': 'Sales', 'messages': 'Messages', 'profile': 'Profile',
      'search': 'Search', 'settings': 'Settings', 'logout': 'Log Out', 'edit_profile': 'Edit Profile',
      'save': 'Save', 'cancel': 'Cancel', 'publish': 'Publish', 'like': 'Like', 'comment': 'Comment',
      'share': 'Share', 'follow': 'Follow', 'books': 'Books', 'reading': 'Reading',
      'what_reading': 'What are you reading?', 'chess': 'Chess', 'play': 'Play',
      'email': 'Email', 'password': 'Password', 'name': 'Name', 'bio': 'Bio', 'username': 'Username',
      'forgot_password': 'Forgot password?', 'no_account': 'No account?',
      'search_users': 'Search users...', 'no_users': 'No users found',
    },
    'es': {
      'app_name': 'READ', 'login': 'Iniciar Sesion', 'register': 'Registrarse', 'guest': 'Entrar como Invitado',
      'home': 'Inicio', 'reels': 'Reels', 'sales': 'Ventas', 'messages': 'Mensajes', 'profile': 'Perfil',
      'search': 'Buscar', 'settings': 'Configuracion', 'logout': 'Cerrar Sesion', 'edit_profile': 'Editar Perfil',
      'save': 'Guardar', 'cancel': 'Cancelar', 'publish': 'Publicar', 'like': 'Me gusta', 'comment': 'Comentar',
      'share': 'Compartir', 'follow': 'Seguir', 'books': 'Libros', 'reading': 'Lectura',
      'what_reading': 'Que estas leyendo?', 'chess': 'Ajedrez', 'play': 'Jugar',
      'email': 'Correo', 'password': 'Contrasena', 'name': 'Nombre', 'bio': 'Bio', 'username': 'Usuario',
      'forgot_password': 'Olvidaste tu contrasena?', 'no_account': 'No tienes cuenta?',
      'search_users': 'Buscar usuarios...', 'no_users': 'No hay usuarios',
    },
    'pt': {
      'app_name': 'READ', 'login': 'Entrar', 'register': 'Cadastrar', 'guest': 'Entrar como Convidado',
      'home': 'Inicio', 'reels': 'Reels', 'sales': 'Vendas', 'messages': 'Mensagens', 'profile': 'Perfil',
      'search': 'Buscar', 'settings': 'Configuracoes', 'logout': 'Sair', 'edit_profile': 'Editar Perfil',
      'save': 'Salvar', 'cancel': 'Cancelar', 'publish': 'Publicar', 'like': 'Curtir', 'comment': 'Comentar',
      'share': 'Compartilhar', 'follow': 'Seguir', 'books': 'Livros', 'reading': 'Leitura',
      'what_reading': 'O que esta lendo?', 'chess': 'Xadrez', 'play': 'Jogar',
      'email': 'E-mail', 'password': 'Senha', 'name': 'Nome', 'bio': 'Bio', 'username': 'Usuario',
      'forgot_password': 'Esqueceu a senha?', 'no_account': 'Nao tem conta?',
      'search_users': 'Buscar usuarios...', 'no_users': 'Nenhum usuario',
    },
    'fr': {
      'app_name': 'READ', 'login': 'Connexion', 'register': 'Inscription', 'guest': 'Entrer comme Invite',
      'home': 'Accueil', 'reels': 'Reels', 'sales': 'Ventes', 'messages': 'Messages', 'profile': 'Profil',
      'search': 'Rechercher', 'settings': 'Parametres', 'logout': 'Deconnexion', 'edit_profile': 'Modifier Profil',
      'save': 'Sauvegarder', 'cancel': 'Annuler', 'publish': 'Publier', 'like': "J'aime", 'comment': 'Commenter',
      'share': 'Partager', 'follow': 'Suivre', 'books': 'Livres', 'reading': 'Lecture',
      'what_reading': 'Que lisez-vous?', 'chess': 'Echecs', 'play': 'Jouer',
      'email': 'E-mail', 'password': 'Mot de passe', 'name': 'Nom', 'bio': 'Bio', 'username': "Nom d'utilisateur",
      'forgot_password': 'Mot de passe oublie?', 'no_account': 'Pas de compte?',
      'search_users': 'Rechercher...', 'no_users': 'Aucun utilisateur',
    },
  };

  String translate(String key) {
    return _translations[locale.languageCode]?[key] ?? _translations['es']?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'es', 'pt', 'fr'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);
  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
