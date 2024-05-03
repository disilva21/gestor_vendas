class ValidarCelular {
  static bool validarNumeroCelular(String value) {
    String pattern = r'^\(?[1-9]{2}\)? ?(?:[2-8]|9[1-9])[0-9]{3}\-?[0-9]{4}$';
    bool valido = false;

    if (RegExp(pattern).hasMatch(value)) {
      valido = true;
    }
    return valido;
  }

  static String normalizarCelular(String value) {
    return value.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '');
  }
}
