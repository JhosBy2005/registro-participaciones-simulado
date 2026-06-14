# Registro de participaciones simulado

Este repositorio contiene materiales para generar y revisar un registro simulado de participaciones de un proyecto universitario.

## Contenido

- `registro_participaciones_simulado.bat`: genera un archivo `.txt` con participaciones simuladas por semana.
- `registro_participaciones_simulado.txt`: ejemplo ya generado del registro simulado.
- `crear_repositorio_github.bat`: automatiza la creacion de este repositorio en GitHub usando Git y GitHub CLI.

## Nota importante

Este material es una simulacion. No representa historial Git real, no crea commits con autores falsos y no debe presentarse como evidencia de actividad real en GitHub.

## Como generar el registro

Ejecuta:

```bat
registro_participaciones_simulado.bat
```

El script generara o reemplazara:

```text
registro_participaciones_simulado.txt
```

## Como crear el repositorio en GitHub

Requisitos:

- Git para Windows instalado.
- GitHub CLI instalado.
- Sesion iniciada con:

```bat
gh auth login
```

Luego ejecuta:

```bat
crear_repositorio_github.bat
```

El script pedira el nombre del repositorio y si debe ser publico o privado. Despues inicializara Git, creara un commit real con estos archivos y publicara el repositorio en tu cuenta de GitHub.
