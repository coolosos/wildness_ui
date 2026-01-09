import 'dart:io';
import 'package:yaml/yaml.dart';

void main() async {
  const dependabotFilePath = '.github/dependabot.yml';

  print("🔍 Buscando directorios con 'pubspec.yaml'...");

  // --- 1. Obtain directores with (pubspec.yaml) ---
  final allPackages = await findPubspecDirectories();
  print(
    '✅ Encontrados ${allPackages.length} directorios con pubspec.yaml (incluida la raíz).',
  );

  // --- 2. Obtain dependabot.yaml list ---
  final dependabotDirectories = await getDependabotDirectories(
    dependabotFilePath,
  );
  print(
    '✅ Encontrados ${dependabotDirectories.length} directorios configurados en $dependabotFilePath.',
  );

  // --- 3. Compare ---
  final missingDirectories = findMissingDirectories(
    allPackages,
    dependabotDirectories,
  );

  // --- 4. Show result ---
  print('\n--- Resultados ---');
  if (missingDirectories.isEmpty) {
    print(
      "✅ ¡Éxito! Todos los paquetes con 'pubspec.yaml' están cubiertos en $dependabotFilePath.",
    );
    exit(0);
  } else {
    print(
      "❌ Error: Los siguientes directorios con 'pubspec.yaml' NO tienen una entrada en $dependabotFilePath:",
    );
    print(
      '--------------------------------------------------------------------------------',
    );
    for (final missing in missingDirectories) {
      print('  - $missing');
    }
    print(
      '--------------------------------------------------------------------------------',
    );
    exit(1);
  }
}

/// Busca recursivamente directorios que contienen un archivo 'pubspec.yaml'.
/// Normaliza las rutas para que empiecen con '/' y terminen con '/'.
Future<Set<String>> findPubspecDirectories() async {
  final directories = <String>{};
  final currentDir = Directory.current;

  // Usa la API de listado recursivo
  await for (final entity in currentDir.list(
    recursive: true,
    followLinks: false,
  )) {
    if (entity is File && entity.path.endsWith('pubspec.yaml')) {
      // Obtenemos la ruta del directorio
      final dirPath = entity.parent.path;

      if (dirPath.contains('.dart_tool') || dirPath.contains('__brick__')) {
        continue;
      }

      // Normalizamos la ruta:
      var normalizedPath = dirPath.replaceAll(currentDir.path, '');

      if (normalizedPath.isEmpty) {
        // Es la raíz del proyecto
        normalizedPath = '/';
      } else {
        // Es un subdirectorio
        if (!normalizedPath.startsWith('/')) {
          normalizedPath = '/$normalizedPath';
        }
        if (!normalizedPath.endsWith('/')) {
          normalizedPath = '$normalizedPath/';
        }
      }
      directories.add(normalizedPath);
    }
  }
  return directories;
}

/// Lee el archivo dependabot.yaml y extrae todas las rutas de 'directory'.
/// Normaliza las rutas para que empiecen con '/' y terminen con '/'.
Future<Set<String>> getDependabotDirectories(String path) async {
  final directories = <String>{};
  final file = File(path);

  if (!await file.exists()) {
    print('Advertencia: Archivo Dependabot no encontrado en $path');
    return exit(0);
  }

  final yamlContent = await file.readAsString();
  final yamlMap = loadYaml(yamlContent) as YamlMap;

  final updates = yamlMap['updates'] as YamlList?;
  if (updates == null) {
    return directories;
  }

  for (final updateEntry in updates) {
    if (updateEntry is YamlMap) {
      final directory = updateEntry['directory'] as String?;
      if (directory != null) {
        // Normalizamos la ruta:
        var normalizedPath = directory;
        if (!normalizedPath.startsWith('/')) {
          normalizedPath = '/$normalizedPath';
        }
        if (normalizedPath != '/' && !normalizedPath.endsWith('/')) {
          normalizedPath = '$normalizedPath/';
        }
        normalizedPath = normalizedPath.replaceAll('/./', '/');

        directories.add(normalizedPath);
      }
    }
  }
  return directories;
}

/// Compara la lista de paquetes encontrados con los configurados en Dependabot.
Set<String> findMissingDirectories(
  Set<String> allPackages,
  Set<String> dependabotDirectories,
) {
  final missing = <String>{};
  for (final packageDir in allPackages) {
    if (!dependabotDirectories.contains(packageDir)) {
      missing.add(packageDir);
    }
  }
  return missing;
}
