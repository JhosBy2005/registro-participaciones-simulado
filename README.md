# FakeJobDetector

Proyecto web para apoyar la deteccion de ofertas laborales sospechosas o fraudulentas. La pagina presenta señales de alerta, recursos de verificacion y una experiencia de analisis orientada a usuarios que buscan empleo.

## Archivos principales

- `index.html`: pagina web final del proyecto.
- `css/styles.css`: estilos de la pagina.
- `js/main.js`: interacciones y logica del sitio.
- `assets/`: carpeta para recursos estaticos del proyecto.
- `registro_participaciones_simulado.bat`: generador local de un registro simulado de participaciones.
- `registro_participaciones_simulado.txt`: registro simulado generado para planificacion o anexo interno.

## Como ver la pagina

Abre `index.html` en el navegador.

## GitHub Pages

Cuando el repositorio este publicado, activa GitHub Pages desde:

```text
Settings > Pages > Build and deployment > Deploy from a branch
```

Selecciona:

```text
Branch: main
Folder: / (root)
```

Luego guarda los cambios. El enlace deberia quedar con este formato:

```text
https://JhosBy2005.github.io/registro-participaciones-simulado/
```

## Participacion del equipo

El archivo `registro_participaciones_simulado.txt` es una simulacion y no representa historial Git real. Para que GitHub muestre participacion real de cada integrante, cada persona debe entrar como colaborador, hacer cambios desde su propia cuenta y subir sus propios commits.

Para invitar colaboradores desde consola puedes usar:

```bat
invitar_colaboradores_github.bat
```

El script requiere GitHub CLI y los usernames de GitHub de cada integrante.

Cuando los colaboradores ya aceptaron la invitacion, cada integrante puede registrar una contribucion real con:

```bat
registrar_participacion_real.bat
```

Ese script debe ejecutarlo cada persona desde su propia cuenta de GitHub. Detecta el usuario autenticado, aplica un cambio pequeno segun su area, crea un commit real y hace push.

## Equipo

- Darnell Cuba `<darnellcuba2006@hotmail.com>`
- Mauricio Valverde `<mauricio.leoval@gmail.com>`
- Jimena Curi `<jimenacha.curi@gmail.com>`
- José Martinez `<jalonso.m.5.7@gmail.com>`
- José Santana `<santanapromaster@gmail.com>`
